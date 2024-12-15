local M = {}

M.get = function(c)
  return {
    -- Yank highlighting
    Yank = { bg = c.green, fg = c.black },

    RenderMarkdownCode = { bg = c.gray1 },
    MarkviewCode = { bg = c.gray1 },
    MarkviewInlineCode = { link = 'MarkviewCode' },
    HelpviewCode = { link = 'MarkviewCode' },
    HelpviewInlineCode = { link = 'MarkviewCode' },
    HelpviewCodeLanguage = { link = 'MarkviewCode' },

    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.yellow },
    DiagnosticInfo = { fg = c.todo },
    DiagnosticHint = { fg = c.hint },

    -- Telescope
    TelescopeNormal = { link = 'NormalFloat' },
    TelescopeBorder = { link = 'FloatBorder' },
    TelescopePromptNormal = { bg = c.prompt },
    TelescopePromptBorder = { fg = c.prompt, bg = c.prompt },

    TelescopeTitle = {},
    TelescopePreviewTitle = { fg = c.red, bold = true, reverse = true },
    TelescopePromptTitle = { fg = c.green, bold = true, reverse = true },

    TelescopeSelection = { bg = c.cursor_line },

    -- Treesitter Context
    TreesitterContext = { bg = c.gray1 },

    -- Ufo fold
    UfoCursorFoldedLine = { bg = c.cursor_line, bold = true },

    -- Indent blankline
    IblIndent = { fg = c.gray1 },

    -- Fzf-Lua
    FzfLuatitle = { fg = c.white, bg = c.float_bg },

    -- Cmp
    CmpItemAbbrMatch = { fg = c.blue },
    CmpItemKind = { fg = c.cyan },
    CmpItemMenu = { fg = c.g4 },

    -- Dashboard
    DashboardHeader = { fg = c.blue },
    DashboardFooter = {},
    ---- General
    DashboardProjectTitle = { fg = c.green },
    DashboardProjectTitleIcon = { fg = c.green },
    DashboardProjectIcon = { fg = c.green },
    DashboardMruTitle = { fg = c.green },
    DashboardMruIcon = { fg = c.green },
    DashboardFiles = { fg = c.gray8 },
    -- for doom theme
    DashboardIcon = { fg = c.green },
    DashboardDesc = { fg = c.green },
    DashboardKey = { fg = c.red },

    -- Neorg
    -- ['@neorg.links.description'] = { underline = true},

    ['@neorg.headings.1.prefix'] = { fg = c.magenta, bold = true },
    ['@neorg.headings.1.title'] = { fg = c.magenta, bold = true },

    ['@neorg.tags.ranged_verbatim.end'] = { fg = c.neorg_tags_ranver_name },
    ['@neorg.tags.ranged_verbatim.begin'] = { fg = c.neorg_tags_ranver_name },
    ['@neorg.tags.ranged_verbatim.name'] = { fg = c.neorg_tags_ranver_name },
    ['@neorg.tags.ranged_verbatim.name.word'] = { fg = c.neorg_tags_ranver_name },
    ['@neorg.tags.ranged_verbatim.name.delimiter'] = { fg = c.neorg_tags_ranver_deli },
    ['@neorg.tags.ranged_verbatim.parameters.word'] = { fg = c.neorg_tags_ranver_para },

    -- Flash
    FlashLabel = { bg = c.yellow, fg = c.black, bold = true },

    LeapMatch = { bg = c.magenta, fg = c.black },
    LeapLabel = { bg = c.magenta, fg = c.black },
    -- LeapBackdrop       = { },

    EyelinerPrimary = { bold = true },
    EyelinerSecondary = { underline = true },
    -- EyelinerPrimary    = { underline = true,  bold = true },
    -- EyelinerSecondary  = { underline = true },

    IlluminatedWordText = { bg = c.gray1 },
    IlluminatedWordRead = { link = 'IlluminatedWordText' },
    IlluminatedWordWrite = { link = 'IlluminatedWordText' },

    -- dapui

    -- DapUINormal                          = { link = 'Normal' },
    -- DapUIVariable                        = { link = 'Normal' },
    -- DapUIEndofBuffer                     = { link = 'EndofBuffer' },

    DapUIScope = { fg = c.magenta, bold = true },

    DapUIType = { fg = c.cyan },
    DapUIValue = { link = 'Normal' },
    DapUIModifiedValue = { fg = c.cyan, bold = true },
    DapUIDecoration = { fg = c.cyan },
    DapUIThread = { fg = c.green },
    DapUIStoppedThread = { fg = c.magenta },
    DapUIFrameName = { link = 'Normal' },
    DapUISource = { fg = c.cyan },
    DapUILineNumber = { fg = c.cyan },
    DapUIFloatNormal = { link = 'NormalFloat' },
    DapUIFloatBorder = { link = 'FloatBorder' },
    DapUICurrentFrameName = { link = 'DapUIBreakpointsCurrentLine' },

    DapUIWatchesEmpty = { fg = c.red },
    DapUIWatchesValue = { fg = c.green },
    DapUIWatchesError = { fg = c.red },

    DapUIBreakpointsPath = { fg = c.magenta, bold = true },
    DapUIBreakpointsInfo = { fg = c.green },
    DapUIBreakpointsCurrentLine = { fg = c.green, bold = true },
    DapUIBreakpointsLine = { link = 'DapUILineNumber' },
    DapUIBreakpointsDisabledLine = { fg = '#424242' },

    DapUIStepOver = { fg = c.cyan },
    DapUIStepInto = { fg = c.cyan },
    DapUIStepBack = { fg = c.cyan },
    DapUIStepOut = { fg = c.cyan },
    DapUIStop = { fg = c.red },
    DapUIPlayPause = { fg = c.green },
    DapUIRestart = { fg = c.green },
    DapUIUnavailable = { fg = c.gray3 },
    DapUIWinSelect = { fg = c.cyan, bold = true },
  }
end

return M
