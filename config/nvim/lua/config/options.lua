-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.spelllang:append("cjk") -- correct Japanese proofreading
vim.opt.autoread = true -- autoread
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "checktime",
})
vim.opt.spell = false -- disables spell check
vim.opt.clipboard = "unnamedplus" -- yy to paste clipboard
vim.g.autoformat = false -- disable format on save
vim.o.laststatus = 0 -- disable status bar
