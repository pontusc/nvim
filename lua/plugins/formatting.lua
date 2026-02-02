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
      alloy = { "alloy_fmt" },
      nix = { "nixfmt" },
    },
    formatters = {
      shfmt = {
        prepend_args = { "-sr" },
      },
      alloy_fmt = {
        command = "alloy",
        args = { "fmt", "-" },
        stdin = true,
      },
      mbake = {
        command = "mbake",
        args = { "format", "--stdin" },
        stdin = true,
      },
    },
  },
}
