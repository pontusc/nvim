return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Show Neovim tab pages as numbers in the statusline (after the filename)
    table.insert(opts.sections.lualine_c, { "tabs", mode = 0 })
  end,
}
