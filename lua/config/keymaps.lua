-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Window navigation
-- Remove existing binding, change to custom
vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Right>")

-- Window navigation
vim.keymap.set("n", "<C-Up>", "<Cmd>TmuxNavigateUp<CR>", {})
vim.keymap.set("n", "<C-Down>", "<Cmd>TmuxNavigateDown<CR>", {})
vim.keymap.set("n", "<C-Left>", "<Cmd>TmuxNavigateLeft<CR>", {})
vim.keymap.set("n", "<C-Right>", "<Cmd>TmuxNavigateRight<CR>", {})
-- vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Go to Upper Window" })
-- vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Go to Lower Window" })
-- vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Go to Left Window" })
-- vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Go to Right Window" })

-- Window resizing
vim.keymap.set("n", "<C-A-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
