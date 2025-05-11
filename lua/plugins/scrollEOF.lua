-- Plugin that manages vim.opt.scrolloff to also work below end of file
return {
  "Aasim-A/scrollEOF.nvim",
  event = { "CursorMoved", "WinScrolled" },
  opts = {},
}
