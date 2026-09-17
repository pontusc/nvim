-- For local development, swap
-- the url line back to: dir = "/home/pontusc/Work/revue"
return {
  {
    url = "git@github.com:pontusc-alchemy/revue.git",
    name = "revue.nvim",
    tag = "v0.2.1",
    -- The plugin arranges its own laziness: plugin/revue.lua only registers
    -- :Revue and the <Plug> maps (deferred requires), so eager load is cheap
    -- and no cmd/keys lazy-load triggers are needed. Keymaps come from
    -- config.keymaps and are bound by the plugin itself.
    lazy = false,
    opts = {
      export = { clear_after_export = true },
    },
  },
}
