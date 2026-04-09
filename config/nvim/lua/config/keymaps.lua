-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "Q", "<leader>bd", { remap = true, desc = "Close Buffer" }) --- keymaps.luaの5行目を以下に変更
vim.keymap.set("t", "<C-h>", "<BS>", { noremap = true, silent = true })

-- 画像貼り付け
vim.keymap.set("n", "<leader>ps", function()
  local path = vim.fn.input("Save to: ", vim.fn.getcwd() .. "/", "file")
  if path ~= "" then
    local cmd = string.format(
      [[osascript -e 'set f to (open for access POSIX file "%s" with write permission)' -e 'write (the clipboard as «class PNGf») to f' -e 'close access f']],
      path
    )
    local result = os.execute(cmd)
    if result then
      print("Saved: " .. path)
    else
      print("Failed. Is clipboard image PNG?")
    end
  end
end)
