-- Small color utility helpers. Inspired by folke/tokyonight.nvim and
-- catppuccin/nvim. Keeps the colorscheme self-contained without pulling in
-- any external dependencies.

local M = {}

---Parse a "#rrggbb" string into { r, g, b } each in 0-255.
---@param hex string
---@return integer, integer, integer
local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---Render three 0-255 channels back into a "#rrggbb" string.
local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
end

---Linear blend of two hex colors.
---@param fg string foreground hex (e.g. "#aabbcc")
---@param bg string background hex
---@param alpha number in [0, 1]; higher = more foreground
---@return string
function M.blend(fg, bg, alpha)
  local fr, fgg, fb = hex_to_rgb(fg)
  local br, bgg, bb = hex_to_rgb(bg)
  local r = fr * alpha + br * (1 - alpha)
  local g = fgg * alpha + bgg * (1 - alpha)
  local b = fb * alpha + bb * (1 - alpha)
  return rgb_to_hex(r, g, b)
end

---Blend `fg` on top of the theme background.
function M.blend_bg(fg, bg, alpha)
  return M.blend(fg, bg, alpha)
end

---Lighten a color by mixing toward white.
function M.lighten(hex, amount)
  return M.blend("#ffffff", hex, amount)
end

---Darken a color by mixing toward black.
function M.darken(hex, amount)
  return M.blend("#000000", hex, amount)
end

return M
