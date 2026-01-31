-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Sync Neovim working directory with LazyGit worktree changes
local lazygit_group = vim.api.nvim_create_augroup("lazygit_worktree_sync", { clear = true })
local initial_worktree = nil

-- Helper function to get git worktree path
local function get_git_worktree()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if not handle then
    return nil
  end

  local path = handle:read("*a")
  local exit_code = handle:close()

  if not exit_code then
    return nil
  end

  path = path:gsub("%s+$", "") -- trim whitespace
  return path ~= "" and path or nil
end

-- Helper function to get most recent repo from LazyGit state
local function get_lazygit_recent_repo()
  local state_file = vim.fn.expand("~/.local/state/lazygit/state.yml")
  local file = io.open(state_file, "r")
  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()

  -- Parse the first repo from recentrepos list
  -- Format is: recentrepos:\n    - /path/to/repo
  local recent_repo = content:match("recentrepos:%s*\n%s*-%s*([^\n]+)")
  return recent_repo
end

vim.api.nvim_create_autocmd("TermOpen", {
  group = lazygit_group,
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)

    -- Check if this is a lazygit terminal
    if bufname:match("lazygit") then
      initial_worktree = get_git_worktree()
    end
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  group = lazygit_group,
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)

    -- Check if this is a lazygit terminal
    if bufname:match("lazygit") then
      vim.defer_fn(function()
        -- Get the most recent repo from LazyGit's state file
        local recent_repo = get_lazygit_recent_repo()

        -- Only update if we have valid paths and they differ
        if not recent_repo or not initial_worktree then
          initial_worktree = nil
          return
        end

        -- Normalize paths for comparison
        recent_repo = vim.fn.fnamemodify(recent_repo, ":p"):gsub("/$", "")
        local initial = vim.fn.fnamemodify(initial_worktree, ":p"):gsub("/$", "")

        if recent_repo ~= initial then
          local ok, err = pcall(vim.fn.chdir, recent_repo)
          if ok then
            local worktree_name = vim.fn.fnamemodify(recent_repo, ":t")

            -- Close all buffers from the old worktree
            local buffers_closed = 0
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(bufnr) then
                local bufpath = vim.api.nvim_buf_get_name(bufnr)
                -- Check if buffer is from the old worktree
                if bufpath:find(initial, 1, true) == 1 then
                  -- Try to find equivalent file in new worktree
                  local relative_path = bufpath:sub(#initial + 2) -- +2 to skip the trailing slash
                  local new_path = recent_repo .. "/" .. relative_path

                  -- Check if equivalent file exists in new worktree
                  if vim.fn.filereadable(new_path) == 1 then
                    -- Open the equivalent file in the new worktree
                    vim.api.nvim_buf_set_name(bufnr, new_path)
                    -- Reload the buffer content
                    vim.api.nvim_buf_call(bufnr, function()
                      vim.cmd("edit!")
                    end)
                  else
                    -- File doesn't exist in new worktree, close the buffer
                    pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
                    buffers_closed = buffers_closed + 1
                  end
                end
              end
            end

            -- Also update the current directory for all windows
            vim.cmd("tcd " .. vim.fn.fnameescape(recent_repo))

            vim.notify(
              string.format("Switched to worktree: %s", worktree_name),
              vim.log.levels.INFO
            )
          else
            vim.notify(
              string.format("Failed to change directory: %s", err),
              vim.log.levels.ERROR
            )
          end
        end

        initial_worktree = nil
      end, 50)
    end
  end,
})
