local M = {}

-- see :h highlight-groups

M.get = function(c)
  return {
    Normal = { fg = c.fg, bg = c.none },
    NormalNC = 'Normal',
    NormalFloat = { fg = c.fg, bg = c.bg_float },
    FloatBorder = { fg = c.bg_float, bg = c.bg_float },
    FloatTitle = { fg = c.title, bg = c.bg_float, bold = true },
    FloatFooter = { fg = c.fg, bg = c.bg_float },
    WinSeparator = { fg = c.border },

    StatusLine = { fg = c.status_line, bold = true },
    StatusLineNC = { fg = c.status_line },
    TabLine = { fg = c.status_line },
    TabLineFill = {},
    TabLineSel = { fg = c.fg, bold = true },
    WinBar = 'StatusLine',
    WinBarNC = 'StatusLineNc',

    -- Pmenu = {},
    -- PmenuSel = {},
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
    TermCursorNC = 'Cursor',

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

    DiffAdd = { fg = c.diff.add },
    DiffChange = { fg = c.diff.change },
    DiffDelete = { fg = c.diff.delete },
    DiffText = { fg = c.comment },

    SpellBad = { sp = c.error, undercurl = true },
    SpellCap = { sp = c.warning, undercurl = true },
    SpellLocal = { sp = c.hint, undercurl = true },
    SpellRare = { sp = c.hint, undercurl = true },

    -- extra
    -- diffAdded = { link = 'DiffAdd' },
    -- diffRemoved = { link = 'DiffDelete' },
    -- diffChanged = { link = 'DiffChange' },
    -- diffFile = { fg = c.cyan },
    -- diffOldFile = { fg = c.cyan },
    -- diffNewFile = { fg = c.cyan },
    --
    -- Added = { link = 'DiffAdd' },
    -- Removed = { link = 'DiffDelete' },
    -- Changed = { link = 'DiffChange' },
  }
end

return M
