return {
  -- Minimalist GitHub PR review + CI logs via the `gh` CLI (replaces octo.nvim).
  -- guh has no setup() — commands register at source time, so cmd-lazy-load works
  -- and no config/opts block is needed. Targets Nvim 0.13+ but has no hard version
  -- gate. Optional deps degrade gracefully (render-markdown present; fugitive/diffs
  -- not), so none are declared.
  "justinmk/guh.nvim",
  cmd = { "Guh", "GuhComment" },
  keys = {
    -- gi/gp/gh* are stock LazyVim git keys; go/gO are free. In-buffer actions
    -- (refresh, diff, CI logs, review, merge, thread, viewed) live inside guh
    -- buffers via its built-in maps — press `g?` there to list them.
    -- Open in a dedicated tab so guh is a self-contained workspace: the layout
    -- underneath is untouched, and you dismiss it with native window commands
    -- (<C-w>c / <C-w>o / :tabclose). No `q` override, so `q` stays macro-record.
    { "<leader>go", "<cmd>tab Guh<cr>", desc = "Guh: open (new tab)" },
    { "<leader>gO", "<cmd>tab Guh .<cr>", desc = "Guh: open target at cursor (new tab)" },
  },
}
