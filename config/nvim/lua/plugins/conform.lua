return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- JS/TS
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },

      -- web
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },

      -- config/data
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },

      -- others
      graphql = { "prettier" },
      vue = { "prettier" },
      svelte = { "prettier" },
    },
  },
}
