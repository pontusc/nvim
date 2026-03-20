return {
  {
    "folke/persistence.nvim",
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("StdinReadPre", {
        callback = function()
          vim.g.started_with_stdin = true
        end,
      })
    end,
    opts = {},
    config = function(_, opts)
      local persistence = require("persistence")
      persistence.setup(opts)

      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("persistence_autoload", { clear = true }),
        nested = true,
        callback = function()
          if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
            persistence.load()
          end
        end,
      })
    end,
  },

  -- Disable dashboard when session will be restored
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      if vim.fn.argc() == 0 then
        opts.dashboard = opts.dashboard or {}
        opts.dashboard.enabled = false
      end
    end,
  },
}
