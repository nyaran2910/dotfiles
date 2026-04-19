return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
    },
    keys = {
      {
        "sp",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep Search",
      },
    },
  },
}
