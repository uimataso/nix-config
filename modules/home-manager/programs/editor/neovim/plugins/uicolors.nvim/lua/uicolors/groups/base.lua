local M = {}

-- see :h highlight-groups
-- see :h expr-highlight

-- run this to get all default hi group in file
-- $ nvim --clean
-- :redir > file
-- :highlight
-- :redir END

M.get = function(c)
  return {
    Normal = { fg = c.fg, bg = c.none },
    NormalNC = 'Normal',
    NormalFloat = 'Normal',
    FloatBorder = { fg = c.border },
    FloatTitle = { fg = c.title, bold = true },
    FloatFooter = { fg = c.fg },
    WinSeparator = { fg = c.border },

    StatusLine = { fg = c.status_line, bold = true },
    StatusLineNC = { fg = c.status_line },
    TabLine = { fg = c.status_line },
    TabLineFill = 'Normal',
    TabLineSel = { fg = c.fg, bold = true },
    WinBar = 'StatusLine',
    WinBarNC = 'StatusLineNc',

    Pmenu = { bg = c.bg_popup },
    PmenuSel = { bg = c.bg_cursor_line },
    -- PmenuKind = {},
    -- PmenuKindSel = {},
    -- PmenuExtra = {},
    -- PmenuExtraSel = {},
    -- PmenuSbar = {},
    -- PmenuThumb = {},
    -- WildMenu = {},

    Cursor = { fg = c.bg, bg = c.fg },
    lCursor = 'Cursor',
    CursorIM = 'Cursor',
    TermCursor = 'Cursor',
    TermCursorNC = 'CursorLine',

    CursorLine = { bg = c.bg_cursor_line },
    CursorLineNr = { fg = c.status_line, bg = c.bg_cursor_line, bold = true },
    CursorLineFold = 'CursorLine',
    CursorLineSign = 'CursorLine',
    CursorColumn = 'CursorLine',
    ColorColumn = 'CursorLine',
    LineNr = { fg = c.non_text },
    LineNrAbove = 'LineNr',
    LineNrBelow = 'LineNr',
    Folded = { bg = c.bg_fold },
    FoldColumn = {},
    SignColumn = {},

    Visual = { bg = c.bg_visual },
    VisualNOS = 'Visual',

    Search = { fg = c.bg, bg = c.search },
    CurSearch = 'Search',
    IncSearch = 'Search',
    Substitute = 'Search',

    NonText = { fg = c.non_text },
    Conceal = 'NonText',
    EndOfBuffer = 'NonText',
    -- SnippetTabstop = {},
    SpecialKey = 'NonText',
    Whitespace = 'NonText',
    MatchParen = { fg = c.guide, bold = true },

    MsgArea = 'Normal',
    MsgSeparator = { fg = c.border, strikethrough = true },
    ErrorMsg = { fg = c.error },
    WarningMsg = { fg = c.warning, bold = true },
    MoreMsg = { fg = c.guide, bold = true },
    ModeMsg = { fg = c.status_line, bold = true },
    Question = { fg = c.guide, bold = true },
    Title = { fg = c.title, bold = true },
    Directory = { fg = c.blue },
    QuickFixLine = { bg = c.bg_qf_select, bold = true },

    DiffAdd = { bg = c.diff.bg_add },
    DiffChange = { bg = c.diff.bg_change },
    DiffDelete = { bg = c.diff.bg_delete },
    DiffText = { bg = c.diff.bg_text },

    SpellBad = { sp = c.error, undercurl = true },
    SpellCap = { sp = c.warning, undercurl = true },
    SpellLocal = { sp = c.hint, undercurl = true },
    SpellRare = { sp = c.hint, undercurl = true },

    -- legacy
    diffAdded = { fg = c.diff.add },
    diffRemoved = { fg = c.diff.delete },
    diffChanged = { fg = c.diff.change },
  }
end

return M
