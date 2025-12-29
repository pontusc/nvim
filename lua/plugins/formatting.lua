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
      hcl = { "terraform_fmt" },
      make = { "mbake" },
    },
    formatters = {
      shfmt = {
        prepend_args = { "-sr" },
      },
      mbake = {
        command = "mbake",
        args = { "format", "--stdin" },
        stdin = true,
      },
    },
  },
}
