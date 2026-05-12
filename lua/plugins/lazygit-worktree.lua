return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>gg",
      function()
        require("util.worktree").open()
      end,
      desc = "Lazygit (worktree-aware)",
    },
    {
      "<leader>gG",
      function()
        require("util.worktree").open({ cwd = vim.fn.getcwd() })
      end,
      desc = "Lazygit cwd (worktree-aware)",
    },
    {
      "<leader>gw",
      function()
        require("util.worktree").pick()
      end,
      desc = "Worktree picker",
    },
  },
  init = function()
    vim.api.nvim_create_user_command("WorktreeAdd", function(opts)
      require("util.worktree").add(opts.args)
    end, {
      nargs = 1,
      desc = "Create git worktree at ../<repo>-<branch> and cd into it",
    })
  end,
}
