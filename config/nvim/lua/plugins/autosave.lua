-- ~/.config/nvim/lua/plugins/auto-save.lua
return {
  "pocco81/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  config = function()
    require("auto-save").setup({
      execution_message = {
        message = function()
          return ""
        end,
      },
    })
  end,
}
