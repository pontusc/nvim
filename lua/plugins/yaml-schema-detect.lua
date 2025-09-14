return {
  "cwrau/yaml-schema-detect.nvim",
  ---@module "yaml-schema-detect"
  ---@type YamlSchemaDetectOptions
  opts = {
    {
      disable_keymap = false,
      keymap = {
        refresh = "<leader>xr",
        cleanup = "<leader>xyc",
        info = "<leader>xyi",
      },
    },
  }, -- use default options
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "yaml" },
}
