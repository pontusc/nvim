-- Statusbar
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  sections = { lualine_c = { '%=', '%t%m', '%3p' } },
}
