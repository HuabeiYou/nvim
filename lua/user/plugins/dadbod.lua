return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql", "javascript" }, lazy = true }, -- Optional
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
        { name = "video_service", url = "mysql://root:savvyuni@localhost:3306/video_service" },
        { name = "ca-erp", url = "mongodb://localhost:27017/erp" },
      }
    end,
  },
  -- { -- optional saghen/blink.cmp completion source
  --   "saghen/blink.cmp",
  --   version = "1.*",
  --   opts = {
  --     sources = {
  --       default = { "lsp", "path", "snippets", "buffer" },
  --       per_filetype = {
  --         sql = { "snippets", "dadbod", "buffer" },
  --       },
  --       -- add vim-dadbod-completion to your completion providers
  --       providers = {
  --         dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
  --       },
  --     },
  --   },
  -- },
}
