-- Entry point for `:colorscheme oc-2`.
--
-- Uses whatever options were previously registered via
-- `require("oc-2").setup({...})`. If the caller hasn't explicitly chosen a
-- style and `vim.o.background` is set to "light", we fall back to the light
-- variant so the standard `:set background=light | colorscheme oc-2` flow
-- still works.

local oc2 = require("oc-2")

local style = oc2.options.style
if not style or style == "auto" then
  style = (vim.o.background == "light") and "light" or "dark"
end

oc2.load({ style = style })
