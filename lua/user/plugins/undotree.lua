return {
  "mbbill/undotree",
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>U", vim.cmd.UndotreeToggle, desc = "Undo Tree" },
    })
  end,
}
