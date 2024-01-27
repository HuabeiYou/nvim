local M = {
  "nvim-lualine/lualine.nvim",
}

function M.config()
  local icons = require("user.icons")
  local diff = {
    "diff",
    colored = false,
    symbols = { added = icons.git.LineAdded, modified = icons.git.LineModified, removed = icons.git.LineRemoved }, -- Changes the symbols used by the diff.
  }

  local diagnostics = {
    "diagnostics",
    sections = { "error", "warn" },
    colored = true,
    always_visible = false, -- Show diagnostics even if there are none.
  }

  local clients_lsp = function()
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return ""
    end

    local c = {}
    for _, client in pairs(clients) do
      table.insert(c, client.name)
    end
    return table.concat(c, icons.ui.LineMiddle)
  end

  require("lualine").setup({
    options = {
      ignore_focus = { "NvimTree" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", diff },
      lualine_c = { "filename", diagnostics },
      lualine_x = { clients_lsp, "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { "quickfix", "man", "fugitive" },
  })
end

return M
