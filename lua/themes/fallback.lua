-- Outside lua/plugins/ so lazy never imports it directly; config.theme_link links it in when Omarchy is absent.
return {
  { "folke/tokyonight.nvim", lazy = true, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
