-- Linting
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      python = { "ruff" },
      sh = { "shellcheck" },
      typescript = { "eslint_d" },
      json = { "jsonlint" },
      yaml = { "yamllint" },
      ansible = { "ansible_lint" },
    }

    -- Simple function to get pip venv python path
    local function get_venv_python()
      local venv_path = os.getenv("VIRTUAL_ENV")
      return venv_path and venv_path .. "/bin/python" or "python"
    end

    lint.linters.pylint.cmd = get_venv_python()
    lint.linters.pylint.args = {
      "-f",
      "text",
      "--disable=C0111",
      "--enable=E,W",
    }

    lint.linters.shellcheck.args = {
      "-x",
      "-e SC1090",
    }

    lint.linters.ansible_lint.args = {
      "--skip-list",
      "no-inventory",
      "-",
    }

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })
  end,
}
