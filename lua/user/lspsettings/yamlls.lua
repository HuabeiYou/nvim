return {
  settings = {
    yaml = {
      schemas = require("schemastore").yaml.schemas(),
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.format({
            range = {
              ["start"] = { 0, 0 },
              ["end"] = { vim.fn.line("$"), 0 },
            },
          })
        end,
      },
    },
  },
}
