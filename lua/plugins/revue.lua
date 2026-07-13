-- For local development, swap
-- the url line back to: dir = "/home/pontusc/Work/revue"
return {
  {
    url = "git@github.com:pontusc-alchemy/revue.git",
    name = "revue.nvim",
    dependencies = { "nvim-mini/mini.diff" },
    -- The plugin arranges its own laziness: plugin/revue.lua only registers
    -- :Revue and the <Plug> maps (deferred requires), so eager load is cheap
    -- and no cmd/keys lazy-load triggers are needed.
    lazy = false,
    -- Global session binds. In-review actions (annotate/edit/export/list/...)
    -- are buffer-local <leader>r* binds set by the plugin inside review buffers.
    keys = {
      { "<leader>rv", "<cmd>Revue start<cr>", desc = "Revue: start review" },
      { "<leader>rq", "<cmd>Revue quit<cr>", desc = "Revue: quit review" },
      { "<leader>rp", "<cmd>Revue preview<cr>", desc = "Revue: preview export" },
    },
    opts = {},
  },
}
