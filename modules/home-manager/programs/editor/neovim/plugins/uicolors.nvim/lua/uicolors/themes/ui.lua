local c = require('uicolors.colors')

return {
  Normal = { fg = c.fg, bg = c.background },
  NormalNC = { link = 'Normal' },
  NormalFloat = { fg = c.fg, bg = c.float_bg },

  Cursor = { fg = c.fg, bg = c.bg, reverse = true },
  lCursor = { link = 'Cursor' },
  -- CursorIM           = { },
  TermCursor = { link = 'Cursor' },
  TermCursorNC = {},

  CursorLine = { bg = c.cursor_line },
  CursorColumn = { link = 'CursorLine' },
  LineNr = { fg = c.nontext },
  LineNrAbove = { link = 'LineNr' },
  LineNrBelow = { link = 'LineNr' },
  SignColumn = {},
  FoldColumn = {},
  CursorLineNr = { bg = c.cursor_line, bold = true },
  CursorLineSign = { link = 'CursorLineNr' },
  CursorLineFlod = { link = 'CursorLineNr' },

  MsgArea = {},
  ModeMsg = { bold = true },
  WarningMsg = { fg = c.yellow, bold = true },
  ErrorMsg = { fg = c.red, bold = true },
  MoreMsg = { fg = c.green },
  Question = { fg = c.green, bold = true },
  QuickFixLine = { fg = c.magenta, bold = true },
  MsgSeparator = { fg = c.nontext, strikethrough = true },
  WinSeparator = { fg = c.nontext },

  StatusLine = { fg = c.gray8, bg = c.gray0, bold = true },
  StatusLineNC = { fg = c.gray0 },

  TabLine = { fg = c.gray5, bold = true },
  TabLineSel = { bold = true },
  TabLineFill = {},

  WinBar = { link = 'TabLineSel' },
  WinBarNC = { link = 'TabLine' },

  Pmenu = { bg = c.gray2 },
  PmenuSel = { bg = c.gray4 },
  PmenuSbar = { link = 'Pmenu' },
  PmenuThumb = { link = 'PmenuSel' },
  WildMenu = {},

  FloatBorder = { fg = c.float_bg, bg = c.float_bg },
  -- FloatShadow        = { },
  -- FloatShadowThrough = { },

  Visual = { bg = c.gray3 },
  -- VisualNOS          = { },
  Search = { fg = c.black, bg = c.yellow },
  IncSearch = { link = 'Search' },
  Substitute = { link = 'Search' },
  CurSearch = { link = 'Search' },

  SpellBad = { fg = c.red, underline = true },
  SpellCap = { fg = c.yellow, underline = true },
  SpellLocal = { fg = c.yellow, underline = true },
  SpellRare = { fg = c.yellow, underline = true },

  DiffAdd = { fg = c.green },
  DiffChange = { fg = c.blue },
  DiffDelete = { fg = c.red },
  DiffText = { fg = c.fg },

  NonText = { fg = c.nontext },
  EndOfBuffer = { link = 'NonText' },
  SpecialKey = { link = 'NonText' },
  Whitespace = { fg = c.gray3 },
  ColorColumn = { bg = c.nontext },
  MatchParen = { fg = c.green, bold = true },
  Folded = { fg = c.gray7, bg = c.gray0, bold = true },
  Title = { fg = c.magenta, bold = true },
  Directory = { fg = c.cyan }, --todo
  Conceal = {}, --todo

  diffAdded = { link = 'DiffAdd' },
  diffRemoved = { link = 'DiffDelete' },
  diffChanged = { link = 'DiffChange' },
  diffFile = { fg = c.cyan },
  diffOldFile = { fg = c.cyan },
  diffNewFile = { fg = c.cyan },

  Added = { link = 'DiffAdd' },
  Removed = { link = 'DiffDelete' },
  Changed = { link = 'DiffChange' },
}
