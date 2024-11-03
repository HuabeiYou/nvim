return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    vim.g.dbs = {
      { name = "intl-erp", url = "mysql://root:savvyuni@localhost:3306/intl-erp" },
      { name = "ca-erp", url = "mongodb://localhost:27017/erp" },
    }
  end,
}
