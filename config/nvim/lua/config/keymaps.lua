-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "Q", "<leader>bd", { remap = true, desc = "Close Buffer" })
vim.keymap.set("t", "<C-h>", "<BS>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>yc", function()
  local path = vim.fn.expand("%:.")

  -- Visualかどうか判定
  local mode = vim.fn.mode()

  local text

  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual選択範囲
    local start_line = vim.fn.getpos("v")[2]
    local end_line = vim.fn.getpos(".")[2]

    -- 順序保証（逆方向選択対策）
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    text = string.format("%s:%d-%d", path, start_line, end_line)
  else
    -- 通常モード
    local line = vim.fn.line(".")
    text = string.format("%s:%d", path, line)
  end

  vim.fn.setreg("+", text)
  print("Copied: " .. text)
end, { desc = "Copy file:line or range" })
