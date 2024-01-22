local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
}

function M.config()
  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "tsserver",
    "pyright",
    "bashls",
    "jsonls",
  }

  require("mason").setup({
    ui = {
      border = "single",
    },
  })

  require("mason-lspconfig").setup({
    ensure_installed = servers,
  })

  local wk = require("which-key")
  wk.register({
    ["<leader>lI"] = { "<cmd>Mason<cr>", "Mason Info" },
  })
end

return M
