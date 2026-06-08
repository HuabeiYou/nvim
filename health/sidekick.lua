local M = {}

function M.check()
  pcall(function()
    require("lazy").load({ plugins = { "sidekick.nvim" } })
  end)

  require("sidekick.health").check()
end

return M
