return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function()
    require("oil").setup({
      columns = { "icon" },
      view_options = { show_hidden = true },
      default_file_explorer = true,
      keymaps = {
        ["<Esc><Esc>"] = { "actions.close", mode = "n" },
      },

      float = {
        border = "rounded",
      },

      confirmation = {
        border = "rounded",
      },

      ssh = {
        border = "rounded",
      },

      keymaps_help = {
        border = "rounded",
      },

      progress = {
        border = "rounded",
      },

      -- Open parent dir in current window
      -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),

      -- Open parent dir in floating window
      vim.keymap.set("n", "-", require("oil").toggle_float, { desc = "Open floating parent directory" }),
    })
  end,
}
