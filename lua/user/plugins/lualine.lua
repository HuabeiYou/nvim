local M = {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
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
      local clients = vim.lsp.get_clients({
        bufnr = vim.api.nvim_get_current_buf(),
      })
      if next(clients) == nil then
        return ""
      end

      local c = {}
      for _, client in pairs(clients) do
        table.insert(c, client.name)
      end
      return table.concat(c, icons.ui.LineMiddle)
    end
    -- require("lualine").setup({
    --   tabline = {},
    --   winbar = {},
    --   inactive_winbar = {},
    -- })
    opts.options = {
      ignore_focus = { "NvimTree" },
    }
    opts.extensions = { "quickfix", "man", "fugitive" }
    opts.sections = opts.sections or {}
    opts.sections.lualine_c = opts.sections.lualine_c or {}
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    opts.sections = {
      lualine_a = {},
      lualine_b = { "branch", diff },
      lualine_c = { "filename", diagnostics },
      lualine_x = { clients_lsp },
      lualine_y = {},
      lualine_z = {},
    }
    opts.inactive_sections = {
      lualine_a = {},
      lualine_b = { "branch", diff },
      lualine_c = { "filename", diagnostics },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

    -- Copilot status
    table.insert(opts.sections.lualine_x, {
      function()
        return " "
      end,
      color = function()
        local status = require("sidekick.status").get()
        if status then
          return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
        end
      end,
      cond = function()
        local status = require("sidekick.status")
        return status.get() ~= nil
      end,
    })

    -- CLI session status
    table.insert(opts.sections.lualine_y, {
      function()
        local status = require("sidekick.status").cli()
        return " " .. (#status > 1 and #status or "")
      end,
      cond = function()
        return #require("sidekick.status").cli() > 0
      end,
      color = function()
        return "Special"
      end,
    })
  end,
}

return M
