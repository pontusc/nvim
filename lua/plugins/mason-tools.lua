return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      -- Formatters
      "beautysh",
      "prettier",
      "yamlfmt",
      "black",
      "terraform",
      "mbake",

      -- Linters
      "ruff", -- python
      "shellcheck",
      "eslint_d", -- Typescript, JS
      "jsonlint",
      "yamllint",
      "ansible-lint",
    },
  },
}
