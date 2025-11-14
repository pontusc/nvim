return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      python = { "ruff" },
      typescript = { "eslint_d" },
      json = { "jsonlint" },
      yaml = { "yamllint" },
      ansible = { "ansible_lint" },
    },
  },
}
