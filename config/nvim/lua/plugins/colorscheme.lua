local function is_macos_dark()
  local out = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null")
  return out:match("Dark") ~= nil
end

local function apply_system_colorscheme()
  local dark = is_macos_dark()
  local scheme = dark and "kanagawa-wave" or "catppuccin-latte"

  vim.o.background = dark and "dark" or "light"

  if vim.g.nyaran_system_colorscheme ~= scheme then
    vim.cmd.colorscheme(scheme)
    vim.g.nyaran_system_colorscheme = scheme
  end
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "latte",
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
    init = function()
      vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
        group = vim.api.nvim_create_augroup("SystemColorscheme", { clear = true }),
        callback = apply_system_colorscheme,
      })
    end,
    opts = {
      colorscheme = apply_system_colorscheme,
    },
  },
}
