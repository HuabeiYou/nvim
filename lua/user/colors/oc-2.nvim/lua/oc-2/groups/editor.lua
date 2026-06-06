-- Core editor highlight groups: UI chrome, windows, gutter, statusline,
-- diagnostics, search, diffs, spelling, messages, etc.
-- These match the tokens defined in lua/oc-2/palette.lua and mirror the
-- semantic roles used by opencode's oc-2 theme.

local M = {}

function M.get(c)
  return {
    -- Backdrop / editor area
    Normal       = { fg = c.fg_strong, bg = c.bg },
    NormalNC     = { fg = c.fg, bg = c.bg },
    NormalFloat  = { fg = c.fg_strong, bg = c.bg_float },
    FloatBorder  = { fg = c.border_weak, bg = c.bg_float },
    FloatTitle   = { fg = c.fg_strong, bg = c.bg_float, bold = true },
    SignColumn   = { fg = c.fg_gutter, bg = c.bg },
    FoldColumn   = { fg = c.fg_gutter, bg = c.bg },
    Folded       = { fg = c.fg_dark, bg = c.bg_highlight },
    EndOfBuffer  = { fg = c.bg },
    NonText      = { fg = c.fg_gutter },
    Whitespace   = { fg = c.fg_gutter },
    SpecialKey   = { fg = c.fg_gutter },
    MatchParen   = { fg = c.cyan, bg = c.bg_match, bold = true },
    Conceal      = { fg = c.fg_dark },
    Directory    = { fg = c.blue },
    Title        = { fg = c.primary, bold = true },
    ErrorMsg     = { fg = c.error, bold = true },
    WarningMsg   = { fg = c.warning },
    MoreMsg      = { fg = c.cyan },
    ModeMsg      = { fg = c.fg_strong, bold = true },
    Question     = { fg = c.cyan },
    QuickFixLine = { bg = c.bg_highlight, bold = true },

    -- Cursor / visual / search
    Cursor       = { fg = c.bg, bg = c.fg_strong },
    lCursor      = { fg = c.bg, bg = c.fg_strong },
    CursorIM     = { fg = c.bg, bg = c.fg_strong },
    CursorLine   = { bg = c.bg_cursorline },
    CursorColumn = { bg = c.bg_cursorline },
    ColorColumn  = { bg = c.bg_highlight },
    Visual       = { bg = c.bg_selection },
    VisualNOS    = { bg = c.bg_selection },
    Search       = { fg = c.bg_search_fg, bg = c.bg_search },
    IncSearch    = { fg = c.bg, bg = c.primary, bold = true },
    CurSearch    = { fg = c.bg, bg = c.yellow, bold = true },
    Substitute   = { fg = c.bg, bg = c.red },

    -- Line numbers
    LineNr       = { fg = c.fg_gutter, bg = c.bg },
    LineNrAbove  = { fg = c.fg_gutter },
    LineNrBelow  = { fg = c.fg_gutter },
    CursorLineNr = { fg = c.primary, bg = c.bg_cursorline, bold = true },
    CursorLineSign = { bg = c.bg_cursorline },
    CursorLineFold = { bg = c.bg_cursorline, fg = c.fg_gutter },

    -- Splits / windows
    WinSeparator = { fg = c.border_weak, bg = c.bg },
    VertSplit    = { fg = c.border_weak, bg = c.bg },
    WinBar       = { fg = c.fg_dark, bg = c.bg },
    WinBarNC     = { fg = c.fg_gutter, bg = c.bg },

    -- Statusline / tabline
    StatusLine    = { fg = c.fg, bg = c.bg_statusline },
    StatusLineNC  = { fg = c.fg_gutter, bg = c.bg_statusline },
    TabLine       = { fg = c.fg_dark, bg = c.bg_statusline },
    TabLineFill   = { bg = c.bg_statusline },
    TabLineSel    = { fg = c.fg_strong, bg = c.bg, bold = true },

    -- Popup menu
    Pmenu        = { fg = c.fg, bg = c.bg_popup },
    PmenuSel     = { fg = c.fg_strong, bg = c.bg_menu_sel, bold = true },
    PmenuSbar    = { bg = c.bg_highlight },
    PmenuThumb   = { bg = c.border_strong },
    PmenuKind    = { fg = c.blue, bg = c.bg_popup },
    PmenuKindSel = { fg = c.blue, bg = c.bg_menu_sel, bold = true },
    PmenuExtra   = { fg = c.fg_dark, bg = c.bg_popup },
    PmenuExtraSel = { fg = c.fg_dark, bg = c.bg_menu_sel },
    WildMenu     = { fg = c.fg_strong, bg = c.bg_menu_sel },

    -- Diff — use opencode's diff surface tokens directly so added/deleted
    -- regions wash behind text the same way they do in the web UI.
    DiffAdd      = { bg = c["surface-diff-add-weak"] },
    DiffChange   = { bg = c["surface-warning-weak"] },
    DiffDelete   = { bg = c["surface-diff-delete-weak"], fg = c.diff_delete_fg },
    DiffText     = { bg = c["surface-diff-add-base"], bold = true },

    -- Spell
    SpellBad   = { sp = c.error, undercurl = true },
    SpellCap   = { sp = c.warning, undercurl = true },
    SpellLocal = { sp = c.info, undercurl = true },
    SpellRare  = { sp = c.hint, undercurl = true },

    -- Diagnostics ---------------------------------------------------------
    -- Backed by the same resolved tokens opencode uses for icons/text:
    --   icon-critical-base, icon-warning-base, icon-info-base, icon-success-base
    -- The aliases in palette.lua route the "classic" red/yellow/blue/green
    -- seeds through so the gutter signs are unmistakable.
    DiagnosticError  = { fg = c.diag_error },
    DiagnosticWarn   = { fg = c.diag_warn },
    DiagnosticInfo   = { fg = c.diag_info },
    DiagnosticHint   = { fg = c.diag_hint },
    DiagnosticOk     = { fg = c.diag_ok },

    DiagnosticSignError = { fg = c.diag_error, bg = c.bg },
    DiagnosticSignWarn  = { fg = c.diag_warn, bg = c.bg },
    DiagnosticSignInfo  = { fg = c.diag_info, bg = c.bg },
    DiagnosticSignHint  = { fg = c.diag_hint, bg = c.bg },
    DiagnosticSignOk    = { fg = c.diag_ok, bg = c.bg },

    DiagnosticVirtualTextError = { fg = c.diag_error, bg = c["surface-critical-base"] },
    DiagnosticVirtualTextWarn  = { fg = c.diag_warn, bg = c["surface-warning-base"] },
    DiagnosticVirtualTextInfo  = { fg = c.diag_info, bg = c["surface-info-base"] },
    DiagnosticVirtualTextHint  = { fg = c.diag_hint, bg = c["surface-info-base"] },
    DiagnosticVirtualTextOk    = { fg = c.diag_ok, bg = c["surface-success-base"] },

    DiagnosticUnderlineError = { sp = c.diag_error, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = c.diag_warn, undercurl = true },
    DiagnosticUnderlineInfo  = { sp = c.diag_info, undercurl = true },
    DiagnosticUnderlineHint  = { sp = c.diag_hint, undercurl = true },
    DiagnosticUnderlineOk    = { sp = c.diag_ok, undercurl = true },

    DiagnosticFloatingError = { fg = c.diag_error, bg = c.bg_float },
    DiagnosticFloatingWarn  = { fg = c.diag_warn, bg = c.bg_float },
    DiagnosticFloatingInfo  = { fg = c.diag_info, bg = c.bg_float },
    DiagnosticFloatingHint  = { fg = c.diag_hint, bg = c.bg_float },
    DiagnosticFloatingOk    = { fg = c.diag_ok, bg = c.bg_float },

    DiagnosticUnnecessary = { fg = c.fg_gutter },
    DiagnosticDeprecated  = { fg = c.fg_gutter, strikethrough = true },

    -- Healthcheck / messages
    healthError   = { fg = c.error },
    healthSuccess = { fg = c.success },
    healthWarning = { fg = c.warning },
  }
end

return M
