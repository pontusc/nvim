return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        -- Nothing is preselected, so <CR> inserts a newline unless an item was chosen
        list = { selection = { preselect = false, auto_insert = false } },
      },
      sources = {
        providers = {
          -- Skip friendly-snippets' global.json (timeHMS, uuid, copyright, ...)
          snippets = { opts = { global_snippets = {} } },
        },
      },
    },
  },
}
