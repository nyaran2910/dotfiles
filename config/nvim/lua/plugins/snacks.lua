return {
  {
    "folke/snacks.nvim",
    priority = 1000, -- 推奨設定：優先的に読み込む
    lazy = false,    -- snacks本体は軽量なので通常はfalseでOK
    opts = {
      picker = { enabled = true }, -- pickerを有効にする
    },
    keys = {
      {
        "sp",
        function()
          Snacks.picker.smart() -- require("snacks").picker.smart() でもOK
        end,
        desc = "Smart File Search",
      },
    },
  },
}
