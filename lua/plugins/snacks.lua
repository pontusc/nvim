return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          -- Shows gitignored fileds
          -- ignored = true,
          -- Show "hidden" (dotfiles) in filesearch
          hidden = true,
        },
      },
    },
    scroll = {
      enabled = false, -- Disable scrolling animations
    },
  },
}
