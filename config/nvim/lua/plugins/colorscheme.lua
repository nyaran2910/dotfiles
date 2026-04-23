return {
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "light",
    },
  },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      theme = "wave",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local out = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null")
        vim.o.background = out:match("Dark") and "dark" or "light"

        if vim.o.background == "light" then
          vim.cmd.colorscheme("onedark")
        else
          vim.cmd.colorscheme("kanagawa")
        end
      end,
    },
  },
}
