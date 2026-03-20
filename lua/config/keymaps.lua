-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remove LazyVim default window navigation (using Alt+hjkl via vim-tmux-navigator instead)
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")

-- Remove buffer navigation
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Window navigation (vim-tmux-navigator via Alt+hjkl)
vim.keymap.set("n", "<M-h>", "<Cmd>TmuxNavigateLeft<CR>", {})
vim.keymap.set("n", "<M-j>", "<Cmd>TmuxNavigateDown<CR>", {})
vim.keymap.set("n", "<M-k>", "<Cmd>TmuxNavigateUp<CR>", {})
vim.keymap.set("n", "<M-l>", "<Cmd>TmuxNavigateRight<CR>", {})

-- Disable arrow keys (force hjkl)
local noop = { "n", "i", "v" }
for _, mode in ipairs(noop) do
  vim.keymap.set(mode, "<Up>", "<Nop>", { desc = "Use k" })
  vim.keymap.set(mode, "<Down>", "<Nop>", { desc = "Use j" })
  vim.keymap.set(mode, "<Left>", "<Nop>", { desc = "Use h" })
  vim.keymap.set(mode, "<Right>", "<Nop>", { desc = "Use l" })
  vim.keymap.set(mode, "<C-Up>", "<Nop>", {})
  vim.keymap.set(mode, "<C-Down>", "<Nop>", {})
  vim.keymap.set(mode, "<C-Left>", "<Nop>", {})
  vim.keymap.set(mode, "<C-Right>", "<Nop>", {})
end

-- Window resizing (Ctrl+Alt+hjkl)
vim.keymap.set("n", "<C-M-k>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-M-j>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-M-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-M-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
