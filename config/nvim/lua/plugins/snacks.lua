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
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rnix = {
          enabled = false,
        },
        nil_ls = {
          mason = false,
        },
      },
    },
  },
}
