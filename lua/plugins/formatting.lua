return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "black" },
      sh = { "shfmt" },
      json = { "prettier" },
      yaml = { "yamlfmt" },
      ansible = { "yamlfmt" },
      markdown = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      terraform = { "terraform_fmt" },
    },
  },
}
