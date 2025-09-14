-- Highlight, edit, and navigate code
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs", -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      "bash",
      "dockerfile",
      "diff",
      "yaml",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
      "python",
      "hcl",
      "terraform",
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { "ruby" } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-n>",
        node_incremental = "<C-n>",
        scope_incremental = "<C-s>",
        node_decremental = "<C-m>",
      },
    },

    vim.treesitter.language.register("yaml", "yml.ansible"),

    vim.filetype.add({
      pattern = {
        [".*[Dd]ockerfile.*"] = "dockerfile",
      },
    }),
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
