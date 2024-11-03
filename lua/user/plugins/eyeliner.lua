-- Move faster with unique f/F indicators for each word on the line.
local M = {
  "jinh0/eyeliner.nvim",
  event = "VeryLazy",
}

function M.config()
  require("eyeliner").setup({
    highlight_on_key = true,
    dim = true,
    -- filetypes for which eyeliner should be disabled;
    -- e.g., to disable on help files:
    -- disabled_filetypes = {"help"}
    disabled_filetypes = { "help", "Starter" },

    -- buftypes for which eyeliner should be disabled
    -- e.g., disabled_buftypes = {"nofile"}
    disabled_buftypes = { "nofile", "nowrite" },
  })
end

return M
