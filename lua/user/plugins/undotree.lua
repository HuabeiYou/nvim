return {
  "mbbill/undotree",
  config = function()
    local wk = require("which-key")
    wk.register({
      ["<leader>U"] = { vim.cmd.UndotreeToggle, "Undo Tree" },
    })
  end,
}
