-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "Q", "<leader>bd", { remap = true, desc = "Close Buffer" })
vim.keymap.set("t", "<C-h>", "<BS>", { noremap = true, silent = true })
