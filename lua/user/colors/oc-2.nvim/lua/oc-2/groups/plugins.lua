-- Integrations for the plugins actually enabled in this config.
-- Each block is self-contained so it's easy to prune or extend.

local M = {}

function M.get(c)
  local groups = {
    -- Telescope -----------------------------------------------------------
    TelescopeNormal         = { fg = c.fg, bg = c.bg_float },
    TelescopeBorder         = { fg = c.border_weak, bg = c.bg_float },
    TelescopeTitle          = { fg = c.primary, bold = true },
    TelescopePromptNormal   = { fg = c.fg_strong, bg = c.bg_highlight },
    TelescopePromptBorder   = { fg = c.border_weak, bg = c.bg_highlight },
    TelescopePromptTitle    = { fg = c.bg, bg = c.primary, bold = true },
    TelescopePromptPrefix   = { fg = c.primary, bg = c.bg_highlight },
    TelescopePromptCounter  = { fg = c.fg_dark, bg = c.bg_highlight },
    TelescopeResultsNormal  = { fg = c.fg, bg = c.bg_float },
    TelescopeResultsBorder  = { fg = c.border_weak, bg = c.bg_float },
    TelescopeResultsTitle   = { fg = c.bg_float, bg = c.bg_float },
    TelescopePreviewNormal  = { fg = c.fg, bg = c.bg_float },
    TelescopePreviewBorder  = { fg = c.border_weak, bg = c.bg_float },
    TelescopePreviewTitle   = { fg = c.bg, bg = c.green, bold = true },
    TelescopeSelection      = { fg = c.fg_strong, bg = c.bg_menu_sel, bold = true },
    TelescopeSelectionCaret = { fg = c.primary, bg = c.bg_menu_sel },
    TelescopeMultiSelection = { fg = c.primary },
    TelescopeMatching       = { fg = c.cyan, bold = true },

    -- Gitsigns ------------------------------------------------------------
    -- `icon-diff-*-base` is what opencode uses for the gutter glyphs.
    -- `surface-diff-*-weak` mirrors the washed line background the web UI
    -- uses when showing inline hunks.
    GitSignsAdd       = { fg = c["icon-diff-add-base"], bg = c.bg },
    GitSignsChange    = { fg = c["icon-diff-modified-base"], bg = c.bg },
    GitSignsDelete    = { fg = c["icon-diff-delete-base"], bg = c.bg },
    GitSignsUntracked = { fg = c.diag_info, bg = c.bg },
    GitSignsAddNr     = { fg = c["icon-diff-add-base"] },
    GitSignsChangeNr  = { fg = c["icon-diff-modified-base"] },
    GitSignsDeleteNr  = { fg = c["icon-diff-delete-base"] },
    GitSignsAddLn     = { bg = c["surface-diff-add-weak"] },
    GitSignsChangeLn  = { bg = c["surface-warning-weak"] },
    GitSignsDeleteLn  = { bg = c["surface-diff-delete-weak"] },
    GitSignsCurrentLineBlame = { fg = c.fg_gutter, italic = true },

    -- Trouble -------------------------------------------------------------
    TroubleNormal       = { fg = c.fg, bg = c.bg },
    TroubleNormalNC     = { fg = c.fg, bg = c.bg },
    TroubleText         = { fg = c.fg },
    TroubleSource       = { fg = c.fg_dark },
    TroubleCount        = { fg = c.primary, bg = c.bg_highlight },
    TroubleFoldIcon     = { fg = c.fg_dark },
    TroubleIndent       = { fg = c.border_weak },
    TroubleLocation     = { fg = c.fg_dark },
    TroubleCode         = { fg = c.fg_dark },
    TroubleFile         = { fg = c.primary, bold = true },
    TroublePos          = { fg = c.fg_dark },
    TroubleIconError    = { fg = c.error },
    TroubleIconWarning  = { fg = c.warning },
    TroubleIconInformation = { fg = c.info },
    TroubleIconHint     = { fg = c.hint },
    TroubleTextError    = { fg = c.error },
    TroubleTextWarning  = { fg = c.warning },
    TroubleTextInformation = { fg = c.info },
    TroubleTextHint     = { fg = c.hint },

    -- todo-comments -------------------------------------------------------
    -- The plugin expects foreground groups like `TodoFg{keyword}` and
    -- background groups `TodoBg{keyword}`. We map keyword -> semantic color.
    TodoFgFIX   = { fg = c.red },
    TodoFgTODO  = { fg = c.info },
    TodoFgHACK  = { fg = c.warning },
    TodoFgWARN  = { fg = c.warning },
    TodoFgPERF  = { fg = c.hint },
    TodoFgNOTE  = { fg = c.green },
    TodoFgTEST  = { fg = c.hint },
    TodoBgFIX   = { fg = c.bg, bg = c.red, bold = true },
    TodoBgTODO  = { fg = c.bg, bg = c.info, bold = true },
    TodoBgHACK  = { fg = c.bg, bg = c.warning, bold = true },
    TodoBgWARN  = { fg = c.bg, bg = c.warning, bold = true },
    TodoBgPERF  = { fg = c.bg, bg = c.hint, bold = true },
    TodoBgNOTE  = { fg = c.bg, bg = c.green, bold = true },
    TodoBgTEST  = { fg = c.bg, bg = c.hint, bold = true },
    TodoSignFIX  = { link = "TodoFgFIX" },
    TodoSignTODO = { link = "TodoFgTODO" },
    TodoSignHACK = { link = "TodoFgHACK" },
    TodoSignWARN = { link = "TodoFgWARN" },
    TodoSignPERF = { link = "TodoFgPERF" },
    TodoSignNOTE = { link = "TodoFgNOTE" },
    TodoSignTEST = { link = "TodoFgTEST" },

    -- flash.nvim ----------------------------------------------------------
    FlashBackdrop = { fg = c.fg_gutter },
    FlashMatch    = { fg = c.bg, bg = c.cyan, bold = true },
    FlashCurrent  = { fg = c.bg, bg = c.primary, bold = true },
    FlashLabel    = { fg = c.bg, bg = c.red, bold = true },
    FlashPrompt   = { link = "MsgArea" },
    FlashPromptIcon = { fg = c.primary },
    FlashCursor   = { reverse = true },

    -- eyeliner.nvim -------------------------------------------------------
    EyelinerPrimary   = { fg = c.primary, bold = true, underline = true },
    EyelinerSecondary = { fg = c.cyan, underline = true },

    -- harpoon -------------------------------------------------------------
    HarpoonBorder  = { fg = c.border_weak, bg = c.bg_float },
    HarpoonWindow  = { fg = c.fg, bg = c.bg_float },
    HarpoonTitle   = { fg = c.primary, bg = c.bg_float, bold = true },

    -- oil.nvim ------------------------------------------------------------
    OilDir        = { fg = c.blue, bold = true },
    OilDirIcon    = { fg = c.blue },
    OilLink       = { fg = c.cyan, underline = true },
    OilLinkTarget = { fg = c.cyan },
    OilCopy       = { fg = c.green, bold = true },
    OilMove       = { fg = c.warning, bold = true },
    OilChange     = { fg = c.warning, bold = true },
    OilCreate     = { fg = c.green, bold = true },
    OilDelete     = { fg = c.error, bold = true },
    OilPermissionNone  = { fg = c.fg_gutter },
    OilPermissionRead  = { fg = c.yellow },
    OilPermissionWrite = { fg = c.red },
    OilPermissionExecute = { fg = c.green },
    OilTypeDir     = { fg = c.blue },
    OilTypeFile    = { fg = c.fg },
    OilTypeLink    = { fg = c.cyan },
    OilTypeSocket  = { fg = c.pink },
    OilSize        = { fg = c.number },
    OilMtime       = { fg = c.fg_dark },

    -- which-key -----------------------------------------------------------
    WhichKey        = { fg = c.primary },
    WhichKeyGroup   = { fg = c.cyan },
    WhichKeyDesc    = { fg = c.fg },
    WhichKeySeparator = { fg = c.fg_gutter },
    WhichKeyFloat   = { bg = c.bg_float },
    WhichKeyBorder  = { fg = c.border_weak, bg = c.bg_float },
    WhichKeyValue   = { fg = c.fg_dark },

    -- nvim-cmp ------------------------------------------------------------
    CmpItemAbbr               = { fg = c.fg, bg = c.none },
    CmpItemAbbrDeprecated     = { fg = c.fg_dark, strikethrough = true },
    CmpItemAbbrMatch          = { fg = c.cyan, bold = true },
    CmpItemAbbrMatchFuzzy     = { fg = c.cyan, bold = true },
    CmpItemMenu               = { fg = c.fg_dark },
    CmpItemKindDefault        = { fg = c.fg_dark },
    CmpItemKindVariable       = { fg = c.fg_strong },
    CmpItemKindKeyword        = { fg = c.keyword },
    CmpItemKindFunction       = { fg = c.primary },
    CmpItemKindMethod         = { fg = c.primary },
    CmpItemKindConstructor    = { fg = c.type },
    CmpItemKindClass          = { fg = c.type },
    CmpItemKindInterface      = { fg = c.type },
    CmpItemKindStruct         = { fg = c.type },
    CmpItemKindEnum           = { fg = c.type },
    CmpItemKindEnumMember     = { fg = c.constant },
    CmpItemKindConstant       = { fg = c.constant },
    CmpItemKindField          = { fg = c.property },
    CmpItemKindProperty       = { fg = c.property },
    CmpItemKindModule         = { fg = c.pink },
    CmpItemKindSnippet        = { fg = c.green },
    CmpItemKindFile           = { fg = c.fg },
    CmpItemKindFolder         = { fg = c.blue },
    CmpItemKindReference      = { fg = c.cyan },
    CmpItemKindText           = { fg = c.fg_dark },
    CmpItemKindUnit           = { fg = c.type },
    CmpItemKindValue          = { fg = c.number },
    CmpItemKindEvent          = { fg = c.pink },
    CmpItemKindOperator       = { fg = c.operator },
    CmpItemKindTypeParameter  = { fg = c.type },
    CmpItemKindCopilot        = { fg = c.cyan },

    -- mini.nvim -----------------------------------------------------------
    MiniIndentscopeSymbol = { fg = c.border, nocombine = true },
    MiniStarterCurrent    = { bold = true },
    MiniStarterFooter     = { fg = c.comment, italic = true },
    MiniStarterHeader     = { fg = c.primary, bold = true },
    MiniStarterSection    = { fg = c.cyan, bold = true },
    MiniStarterItemBullet = { fg = c.primary },
    MiniStarterItemPrefix = { fg = c.red, bold = true },
    MiniStarterQuery      = { fg = c.cyan },
    MiniCursorword        = { bg = c.bg_visual },
    MiniCursorwordCurrent = { bg = c.bg_visual },
    MiniStatuslineDevinfo = { fg = c.fg_dark, bg = c.bg_statusline },
    MiniStatuslineFilename = { fg = c.fg, bg = c.bg_statusline },
    MiniStatuslineFileinfo = { fg = c.fg_dark, bg = c.bg_statusline },
    MiniStatuslineInactive = { fg = c.fg_gutter, bg = c.bg_statusline },
    MiniStatuslineModeNormal  = { fg = c.bg, bg = c.primary, bold = true },
    MiniStatuslineModeInsert  = { fg = c.bg, bg = c.green, bold = true },
    MiniStatuslineModeVisual  = { fg = c.bg, bg = c.cyan, bold = true },
    MiniStatuslineModeReplace = { fg = c.bg, bg = c.red, bold = true },
    MiniStatuslineModeCommand = { fg = c.bg, bg = c.yellow, bold = true },
    MiniStatuslineModeOther   = { fg = c.bg, bg = c.pink, bold = true },

    -- nvim-navic ----------------------------------------------------------
    NavicIconsFile          = { fg = c.fg, bg = c.none },
    NavicIconsModule        = { fg = c.pink },
    NavicIconsNamespace     = { fg = c.fg_strong },
    NavicIconsPackage       = { fg = c.primary },
    NavicIconsClass         = { fg = c.type },
    NavicIconsMethod        = { fg = c.primary },
    NavicIconsProperty      = { fg = c.property },
    NavicIconsField         = { fg = c.property },
    NavicIconsConstructor   = { fg = c.type },
    NavicIconsEnum          = { fg = c.type },
    NavicIconsInterface     = { fg = c.type },
    NavicIconsFunction      = { fg = c.primary },
    NavicIconsVariable      = { fg = c.fg_strong },
    NavicIconsConstant      = { fg = c.constant },
    NavicIconsString        = { fg = c.string },
    NavicIconsNumber        = { fg = c.number },
    NavicIconsBoolean       = { fg = c.number },
    NavicIconsArray         = { fg = c.cyan },
    NavicIconsObject        = { fg = c.pink },
    NavicIconsKey           = { fg = c.keyword },
    NavicIconsNull          = { fg = c.constant },
    NavicIconsEnumMember    = { fg = c.constant },
    NavicIconsStruct        = { fg = c.type },
    NavicIconsEvent         = { fg = c.pink },
    NavicIconsOperator      = { fg = c.operator },
    NavicIconsTypeParameter = { fg = c.type },
    NavicText               = { fg = c.fg },
    NavicSeparator          = { fg = c.fg_gutter },

    -- indent-blankline ----------------------------------------------------
    IblIndent     = { fg = c.border_weaker, nocombine = true },
    IblWhitespace = { fg = c.border_weaker, nocombine = true },
    IblScope      = { fg = c.fg_dark, nocombine = true },

    -- dressing.nvim -------------------------------------------------------
    DressingInputBorder  = { link = "FloatBorder" },
    DressingSelectBorder = { link = "FloatBorder" },

    -- zen-mode ------------------------------------------------------------
    ZenBg = { bg = c.bg },

    -- LSP references / semantic highlight ---------------------------------
    LspReferenceText  = { bg = c.bg_visual },
    LspReferenceRead  = { bg = c.bg_visual },
    LspReferenceWrite = { bg = c.bg_visual },
    LspInlayHint      = { fg = c.fg_gutter, bg = c.bg_highlight, italic = true },
    LspSignatureActiveParameter = { fg = c.primary, bold = true },
    LspCodeLens       = { fg = c.fg_gutter, italic = true },
    LspCodeLensSeparator = { fg = c.fg_gutter },
    LspInfoBorder     = { link = "FloatBorder" },

    -- tabby ---------------------------------------------------------------
    TabbyCurrent  = { fg = c.fg_strong, bg = c.bg, bold = true },
    TabbyInactive = { fg = c.fg_dark, bg = c.bg_statusline },
    TabbyHead     = { fg = c.primary, bg = c.bg_statusline, bold = true },
    TabbyTail     = { fg = c.primary, bg = c.bg_statusline, bold = true },
    TabbyFill     = { bg = c.bg_statusline },

    -- fugitive / diff-like
    diffAdded   = { fg = c.git_add },
    diffRemoved = { fg = c.git_delete },
    diffChanged = { fg = c.git_change },
    diffLine    = { fg = c.primary },
    diffIndexLine = { fg = c.pink },
    diffFile    = { fg = c.primary },
    diffNewFile = { fg = c.green },
    diffOldFile = { fg = c.red },
  }

  return groups
end

return M
