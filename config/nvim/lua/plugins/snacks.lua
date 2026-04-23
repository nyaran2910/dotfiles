return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
      terminal = {
        win = {
          keys = {
            nav_h = false,
            term_normal = false,
          },
        },
      },
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
