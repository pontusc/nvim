return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "black" },
      sh = { "beautysh" },
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
