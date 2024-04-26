local M = {
  "stevearc/conform.nvim",
  opts = {},
}

function M.config()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "goimports", "gofmt" },
      python = { "isort", "black" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      javascriptreact = { "prettier" },
      handlebars = { "prettier" },
    },
  })
end

return M
