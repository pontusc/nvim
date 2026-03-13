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
        grep = {
          -- Search hidden (dot) files/dirs like .github/
          hidden = true,
          -- Uncomment to also search gitignored files
          -- ignored = true,
        },
      },
    },
    scroll = {
      enabled = false, -- Disable scrolling animations
    },
  },
}
