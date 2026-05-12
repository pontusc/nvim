local M = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "worktree" })
end

local function rebase_buffers(old_root, new_root)
  local old_slash = old_root:gsub("/$", "") .. "/"
  local new_slash = new_root:gsub("/$", "") .. "/"

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and name:sub(1, #old_slash) == old_slash and not vim.bo[buf].modified then
        local new_path = new_slash .. name:sub(#old_slash + 1)
        vim.api.nvim_win_call(win, function()
          vim.cmd("silent! keepalt edit " .. vim.fn.fnameescape(new_path))
        end)
      end
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not vim.bo[buf].modified then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and name:sub(1, #old_slash) == old_slash and vim.fn.bufwinid(buf) == -1 then
        pcall(vim.api.nvim_buf_delete, buf, { force = false })
      end
    end
  end
end

local function chdir(path)
  if not path or path == "" then
    return
  end
  path = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")
  if path == "" or vim.fn.isdirectory(path) == 0 then
    return
  end
  local old = vim.fn.getcwd()
  if old == path then
    return
  end
  vim.cmd.cd(vim.fn.fnameescape(path))
  rebase_buffers(old, path)
  notify("cwd → " .. path)
end

M.debug = false
M.debug_log = "/tmp/lazygit-worktree.log"

local function dbg(msg)
  if not M.debug then
    return
  end
  local f = io.open(M.debug_log, "a")
  if f then
    f:write(os.date("%H:%M:%S ") .. msg .. "\n")
    f:close()
  end
end

function M.open(opts)
  opts = opts or {}
  if not (Snacks and Snacks.lazygit) then
    notify("Snacks.lazygit not available", vim.log.levels.ERROR)
    return
  end

  local tmpfile = vim.fn.tempname()
  local prev = vim.env.LAZYGIT_NEW_DIR_FILE
  vim.env.LAZYGIT_NEW_DIR_FILE = tmpfile
  dbg("LAZYGIT_NEW_DIR_FILE=" .. tmpfile)

  local handled = false
  local group_name = "lazygit-worktree-" .. tostring(vim.loop.hrtime())
  local group = vim.api.nvim_create_augroup(group_name, { clear = true })

  local function finalize()
    if handled then
      return
    end
    handled = true
    vim.env.LAZYGIT_NEW_DIR_FILE = prev
    pcall(vim.api.nvim_del_augroup_by_id, group)
    vim.schedule(function()
      local exists = vim.fn.filereadable(tmpfile) == 1
      dbg(("tmpfile %s exists=%s"):format(tmpfile, tostring(exists)))
      if exists then
        local lines = vim.fn.readfile(tmpfile)
        vim.fn.delete(tmpfile)
        local target = lines and lines[1] or ""
        dbg("tmpfile contents: " .. vim.inspect(lines))
        if target ~= "" then
          chdir(target)
        end
      else
        local dir = vim.fn.fnamemodify(tmpfile, ":h")
        dbg("listing " .. dir .. ":")
        for _, f in ipairs(vim.fn.readdir(dir)) do
          if f:find("nvim", 1, true) or f:find("lazygit", 1, true) then
            dbg("  " .. f)
          end
        end
        dbg("LAZYGIT_NEW_DIR_FILE at finalize=" .. tostring(vim.env.LAZYGIT_NEW_DIR_FILE))
      end
    end)
  end

  vim.api.nvim_create_autocmd("TermClose", {
    group = group,
    callback = function(ev)
      local name = vim.api.nvim_buf_get_name(ev.buf) or ""
      dbg("TermClose buf=" .. ev.buf .. " name=" .. name)
      if not name:lower():find("lazygit") then
        return
      end
      finalize()
    end,
  })

  -- Fallback: if Snacks returns a usable buf, also bind there so we catch
  -- exit even if the buffer name doesn't contain "lazygit".
  local term = Snacks.lazygit(opts)
  if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    dbg("term.buf=" .. term.buf .. " name=" .. (vim.api.nvim_buf_get_name(term.buf) or ""))
    vim.api.nvim_create_autocmd("TermClose", {
      group = group,
      buffer = term.buf,
      callback = finalize,
    })
  end
end

function M.pick()
  local raw = vim.fn.systemlist({ "git", "worktree", "list", "--porcelain" })
  if vim.v.shell_error ~= 0 then
    notify("not in a git repo", vim.log.levels.ERROR)
    return
  end

  local items, cur = {}, {}
  local function flush()
    if cur.path then
      cur.text = string.format("%-30s %s", cur.label or "", cur.path)
      table.insert(items, cur)
    end
    cur = {}
  end
  for _, line in ipairs(raw) do
    if line:sub(1, 9) == "worktree " then
      flush()
      cur.path = line:sub(10)
    elseif line:sub(1, 7) == "branch " then
      cur.branch = line:sub(8):gsub("^refs/heads/", "")
      cur.label = cur.branch
    elseif line:sub(1, 5) == "HEAD " then
      cur.head = line:sub(6, 13)
      cur.label = cur.label or ("(detached " .. cur.head .. ")")
    elseif line == "bare" then
      cur.label = "(bare)"
    end
  end
  flush()

  if #items == 0 then
    notify("no worktrees", vim.log.levels.WARN)
    return
  end

  if not (Snacks and Snacks.picker) then
    vim.ui.select(items, {
      prompt = "Worktree",
      format_item = function(it)
        return it.text
      end,
    }, function(choice)
      if choice then
        chdir(choice.path)
      end
    end)
    return
  end

  Snacks.picker.pick({
    title = "Worktrees",
    items = items,
    format = function(item)
      return {
        { string.format("%-30s ", item.label or ""), "GitBranch" },
        { item.path, "Directory" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        chdir(item.path)
      end
    end,
  })
end

function M.add(branch)
  if not branch or branch == "" then
    notify("usage: :WorktreeAdd <branch>", vim.log.levels.ERROR)
    return
  end
  local toplevel = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
  if vim.v.shell_error ~= 0 or not toplevel or toplevel == "" then
    notify("not in a git repo", vim.log.levels.ERROR)
    return
  end
  -- If currently in a linked worktree, resolve back to the main repo so siblings
  -- are placed next to the canonical repo rather than next to another worktree.
  local common = vim.fn.systemlist({ "git", "rev-parse", "--path-format=absolute", "--git-common-dir" })[1]
  if common and common ~= "" and common:sub(-5) == "/.git" then
    toplevel = common:sub(1, -6)
  end

  local repo = vim.fn.fnamemodify(toplevel, ":t")
  local parent = vim.fn.fnamemodify(toplevel, ":h")
  local safe = branch:gsub("/", "-")
  local path = parent .. "/" .. repo .. "-" .. safe

  if vim.fn.isdirectory(path) == 1 then
    notify(path .. " already exists; cd'ing into it", vim.log.levels.WARN)
    chdir(path)
    return
  end

  vim.fn.system({ "git", "show-ref", "--verify", "--quiet", "refs/heads/" .. branch })
  local cmd
  if vim.v.shell_error == 0 then
    cmd = { "git", "worktree", "add", path, branch }
  else
    cmd = { "git", "worktree", "add", "-b", branch, path }
  end

  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    notify("worktree add failed:\n" .. out, vim.log.levels.ERROR)
    return
  end
  chdir(path)
end

return M
