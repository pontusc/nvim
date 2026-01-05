return
-- Add all LSPs and configs
{
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      basedpyright = {
        settings = {
          basedpyright = {
            disableOrganizedImports = false,
            analysis = {
              typeCheckingMode = "off",
              ignore = { "*" },
            },
          },
        },
      },

      dockerls = {
        settings = {
          docker = {
            languageserver = {
              formatter = {
                ignoreMultilineInstructions = true,
              },
            },
          },
        },
      },

      bashls = {},
      jsonls = {},
      ts_ls = {},
      taplo = {},

      rust_analyzer = {},

      yamlls = {
        filetypes = { "yaml" },
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
            completion = true,
            validate = false,
            format = { enabled = false },
            editor = { tabSize = 2 },
            hover = true,
            schemas = {
              kubernetes = {
                "*.{yml,yaml}",
              },
              ["http://json.schemastore.org/github-workflow"] = {
                ".github/workflows/*",
                "*workflow.{yml,yaml}",
              },
              ["http://json.schemastore.org/github-action"] = {
                ".github/action.{yml,yaml}",
                "*action.{yml,yaml}",
              },
              ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure-pipelines*.{yml,yaml}",
              ["http://json.schemastore.org/cloudbuild"] = "cloudbuild*.{yml,yaml}",
              ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
              ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
              ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
              ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
              ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
                "gitlab-ci*.{yml,yaml}",
                "*gitlab-ci*.{yml,yaml}",
              },
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
              ["https://goauthentik.io/blueprints/schema.json"] = "*blueprint.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
              ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
            },

            -- Enable custom tags for GitLab CI
            customTags = {
              "!reference sequence", -- for !reference tags
            },
            -- Disable schema validation for specific patterns if needed
            disableAdditionalProperties = false,
          },
        },
      },

      helm_ls = {
        settings = {
          ["helm-ls"] = {
            valuesFiles = {
              mainValuesFile = "values.yaml",
              lintOverlayValuesFile = "values.lint.yaml",
              additionalValuesFilesGlobPattern = "values*.{yaml,yml}",
            },
            helmLint = {
              ignoredMessages = {
                "icon is recommended",
              },
            },
            yamlls = {
              enabled = true,
              enabledForFilesGlob = "*.{yaml,yml}",
              diagnosticsLimit = 0,
              showDiagnosticsDirectly = false,
              initTimeoutSeconds = 3,
              path = vim.fn.stdpath("data") .. "/mason/bin/yaml-language-server",
              config = {
                schemas = {
                  kubernetes = "templates/**",
                },
                completion = true,
                hover = true,
                schemaStore = {
                  enable = true,
                  url = "https://www.schemastore.org/api/json/catalog.json",
                },
              },
            },
          },
        },
      },

      ansiblels = {
        filetypes = {
          "ansible",
        },
        settings = {
          ansible = {
            ansible = {
              path = "ansible",
              useFullyQualifiedCollectionNames = true,
            },
            executionEnvironment = {
              enabled = false,
            },
            python = {
              interpreterPath = "python",
            },
            validation = {
              enabled = false,
              lint = {
                enabled = false,
                path = "ansible-lint",
              },
            },
            completion = {
              provideRedirectModules = true,
              provideModuleOptionAliases = true,
            },
          },
        },
        init_options = {
          settings = {
            ansible = {
              ansible = {
                path = "ansible",
              },
              ansibleLint = {
                path = "ansible-lint",
              },
              collections = {
                paths = {
                  "~/.ansible/collections",
                  "/usr/share/ansible/collections",
                  "~/.local/share/pipx/venvs/ansible/lib/python3.12/site-packages",
                },
              },
            },
          },
        },
      },

      terraformls = {},

      hyprls = {},
    },
  },
  setup = {
    -- Taken from LazyVim guide to add Helm, also requires vim.helm plugin
    yamlls = function()
      LazyVim.lsp.on_attach(function(client, buffer)
        if vim.bo[buffer].filetype == "helm" then
          vim.schedule(function()
            vim.cmd("LspStop ++force yamlls")
          end)
        end
      end, "yamlls")
    end,
  },
}
