return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      python = { "ruff" },
      typescript = { "eslint_d" },
      json = { "jsonlint" },
      yaml = { "yamllint" },
      ghaction = { "yamllint", "actionlint" },
      ansible = { "ansible_lint" },
    },
  },
}
