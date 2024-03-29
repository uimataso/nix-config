local util = require 'uicolors.util'
local c = require 'uicolors.colors'

local op_bg = true
local background = op_bg and 'NONE' or c.bg

return {
  --------------------------
  --          UI          --
  --------------------------

  Normal             = { fg = c.fg,                bg = background },
  NormalNC           = { link = 'Normal' },
  NormalFloat        = { fg = c.fg,                bg = c.float_bg },

  Cursor             = { fg = c.fg,                bg = c.bg,     reverse = true },
  lCursor            = { link = 'Cursor' },
  -- CursorIM           = { },
  TermCursor         = { link = 'Cursor' },
  TermCursorNC       = { },

  CursorLine         = { bg = c.cursor_line },
  CursorColumn       = { link = 'CursorLine' },
  LineNr             = { fg = c.nontext },
  LineNrAbove        = { link = 'LineNr' },
  LineNrBelow        = { link = 'LineNr' },
  SignColumn         = { },
  FoldColumn         = { },
  CursorLineNr       = { bg = c.cursor_line,       bold = true },
  CursorLineSign     = { link = 'CursorLineNr' },
  CursorLineFlod     = { link = 'CursorLineNr' },

  MsgArea            = { },
  ModeMsg            = { bold = true},
  WarningMsg         = { fg = c.yellow,            bold = true },
  ErrorMsg           = { fg = c.red,               bold = true },
  MoreMsg            = { fg = c.green },
  Question           = { fg = c.green,             bold = true },
  QuickFixLine       = { fg = c.magenta,           bold = true },
  MsgSeparator       = { fg = c.nontext,           strikethrough = true },
  WinSeparator       = { fg = c.nontext },

  StatusLine         = { fg = c.gray8, bg = c.gray0, bold = true },
  StatusLineNC       = { fg = c.gray0 },

  TabLine            = { fg = c.gray5,             bold = true },
  TabLineSel         = { bold = true },
  TabLineFill        = { },

  WinBar             = { link = 'TabLineSel' },
  WinBarNC           = { link = 'TabLine' },

  Pmenu              = { bg = c.gray2 },
  PmenuSel           = { bg = c.gray4 },
  PmenuSbar          = { link = 'Pmenu' },
  PmenuThumb         = { link = 'PmenuSel' },
  WildMenu           = { },

  FloatBorder        = { fg = c.float_bg,          bg = c.float_bg },
  -- FloatShadow        = { },
  -- FloatShadowThrough = { },

  Visual             = { bg = c.gray3 },
  -- VisualNOS          = { },
  Search             = { fg = c.black,             bg = c.yellow },
  IncSearch          = { link = 'Search' },
  Substitute         = { link = 'Search' },
  CurSearch          = { link = 'Search' },

  SpellBad           = { fg = c.red,               underline = true },
  SpellCap           = { fg = c.yellow,            underline = true },
  SpellLocal         = { fg = c.yellow,            underline = true },
  SpellRare          = { fg = c.yellow,            underline = true },

  DiffAdd            = { fg = c.green },
  DiffChange         = { fg = c.blue },
  DiffDelete         = { fg = c.red },
  DiffText           = { fg = c.fg },

  NonText            = { fg = c.nontext },
  EndOfBuffer        = { link = 'NonText' },
  SpecialKey         = { link = 'NonText' },
  Whitespace         = { fg = c.gray3 },
  ColorColumn        = { bg = c.nontext },
  MatchParen         = { fg = c.green,             bold = true },
  Folded             = { fg = c.gray7,             bg = c.gray0,    bold = true },
  Title              = { fg = c.magenta,           bold = true },
  Directory          = { fg = c.cyan }, --todo
  Conceal            = { }, --todo

  diffAdded          = { link = 'DiffAdd' },
  diffRemoved        = { link = 'DiffDelete' },
  diffChanged        = { link = 'DiffChange' },
  diffFile           = { fg = c.cyan },
  diffOldFile        = { fg = c.cyan },
  diffNewFile        = { fg = c.cyan },



  --------------------------
  --        Syntax        --
  --------------------------

  -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights

  -- Misc --
  ['@comment']               = { fg = c.comment },
  ['@error']                 = { },
  ['@none']                  = { },
  ['@preproc']               = { fg = c.preproc },
  ['@define']                = { link = '@preproc' },
  ['@operator']              = { fg = c.fg },

  -- Punctuation --
  ['@punctuation']           = { fg = c.punctuation },
  ['@punctuation.delimiter'] = { link = '@punctuation' },
  ['@punctuation.bracket']   = { link = '@punctuation' },
  ['@punctuation.special']   = { link = '@punctuation' },

  -- Literals --
  ['@string']                = { fg = c.string },
  ['@string.regex']          = { link = '@string' },
  ['@string.escape']         = { link = '@string.special' },
  ['@string.special']        = { fg = c.red },

  ['@character']             = { link = '@string' },
  ['@character.special']     = { link = '@string.special' },

  ['@boolean']               = { fg = c.value },
  ['@number']                = { link = '@boolean' },
  ['@float']                 = { link = '@boolean' },

  -- Functions --
  ['@function']              = { fg = c.func },
  ['@function.builtin']      = { fg = c.func,         bold = true },
  ['@function.call']         = { link = '@function' },
  ['@function.macro']        = { link = '@function' },

  ['@method']                = { link = '@functin' },
  ['@method.call']           = { link = '@method' },

  ['@constructor']           = { },
  ['@parameter']             = { link = '@variable' },
  ['@parameter.reference']   = { fg = c.variable,     bold = true },

  -- Keywords --
  ['@keyword']               = { fg = c.keyword },
  ['@keyword.function']      = { fg = c.keyword,      bold = true },
  ['@keyword.operator']      = { fg = c.white,        bold = true },
  ['@keyword.return']        = { link = '@preproc' },

  ['@conditional']           = { fg = c.keyword,      bold = true },
  ['@repeat']                = { fg = c.keyword,      bold = true },
  ['@debug']                 = { link = '@preproc' },
  ['@label']                 = { link = '@preproc' },
  ['@include']               = { link = '@preproc' },
  ['@exception']             = { link = '@preproc' },

  -- Types --
  ['@type']                  = { fg = c.type },
  ['@type.builtin']          = { fg = c.type,         bold = true },
  ['@type.definition']       = { link = '@preproc' },
  ['@type.qualifier']        = { link = '@type' },

  ['@storageclass']          = { fg = c.cyan },
  ['@attribute']             = { fg = c.cyan },
  ['@field']                 = { fg = c.field },
  ['@property']              = { link = '@field' },

  -- Identifiers --
  ['@variable']              = { fg = c.variable },
  ['@variable.builtin']      = { fg = c.variable,     bold = true },

  ['@constant']              = { fg = c.constant },
  ['@constant.builtin']      = { fg = c.constant,     bold = true },
  ['@constant.macro']        = { link = '@preproc' },

  ['@namespace']             = { fg = c.namespace },
  ['@symbol']                = { },

  -- Text --
  ['@text']                  = { },
  ['@text.strong']           = { bold = true },
  ['@text.emphasis']         = { italic = true },
  ['@text.underline']        = { underline = true },
  ['@text.strike']           = { strikethrough = true },
  ['@text.title']            = { link = 'Title' },
  ['@text.literal']          = { bg = c.gray1 },
  ['@text.uri']              = { fg = c.uri,          underline = true },
  -- ['@text.math']             = { },
  ['@text.environment']      = { link = '@keyword' },
  ['@text.environment.name'] = { fg = c.blue,         bold = true },
  ['@text.reference']        = { fg = util.blend(c.cyan, c.fg, 0.6) },

  ['@text.todo']             = { fg = c.black, bg = c.cyan, bold = true },
  ['@text.note']             = { link = '@text.todo' },
  ['@text.warning']          = { link = '@text.todo' },
  ['@text.danger']           = { link = '@text.todo' },

  ['@text.diff.add']         = { bg = c.diff_add },
  ['@text.diff.delete']      = { bg = c.diff_delete },

  -- Tags --
  ['@tag']                   = { fg = c.cyan },
  ['@tag.attribute']         = { fg = c.gray8 },
  ['@tag.delimiter']         = { fg = c.gray6 },

  -- Conceal --
  -- ['@conceal']               = { },

  -- Spell --
  -- ['@spell']                 = { },


  -- Fix --
  ['@constant.comment']      = { link = '@comment' },


  -- Filetype --
  ['@field.yaml']            = { fg = c.cyan,         bold = true },
  ['@label.json']            = { fg = c.cyan,         bold = true },

  ['@function.latex']          = { fg = c.cyan },


  -----------------------------
  --  Vanilla Syntax Groups  --
  -----------------------------
  -- links vailla syntax groups to treesitter groups {{{
  Comment          = { link = '@comment' },

  Constant         = { link = '@constant' },
    String         = { link = '@string' },
    Character      = { link = '@character' },
    Number         = { link = '@number' },
    Boolean        = { link = '@boolean' },
    Float          = { link = '@float' },

  Identifier       = { link = '@variable' },
    Function       = { link = '@function' },

  Statement        = { link = '@conditional' },
    Conditional    = { link = '@conditional' },
    Repeat         = { link = '@reqeat' },
    Label          = { link = '@label' },
    Operator       = { link = '@operator' },
    Keyword        = { link = '@keyword' },
    Exception      = { link = '@exception' },

  PreProc          = { link = '@preproc' },
    Include        = { link = '@include' },
    Define         = { link = '@define' },
    Macro          = { link = '@constant.macro' },
    PreCondit      = { link = '@preproc' },

  Type             = { link = '@link' },
    StorageClass   = { link = '@storageclass' },
    Structure      = { link = '@' },
    Typedef        = { link = '@type.definition' },

  Special          = { link = '@character.special' },
    SpecialChar    = { link = '@character.special' },
    Tag            = { link = '@tag' },
    Delimiter      = { link = '@punctuation.delimiter' },
    SpecialComment = { link = '@comment' },
    Debug          = { link = '@debug' },

  Underlined       = { link = '@text.underline' },
  Ignore           = { link = '@none' },
  Error            = { link = '@error' },
  Todo             = { link = '@text.todo' },
  --}}}


  --------------------
  --     Plugin     --
  --------------------

  -- Yank highlighting
  Yank               = { bg = c.green,    fg = c.black },

  DiagnosticError = { fg = c.red },
  DiagnosticWarn  = { fg = c.yellow },
  DiagnosticInfo  = { fg = c.cyan },
  DiagnosticHint  = { fg = c.white },

  -- Telescope
  TelescopeNormal       = { link = 'NormalFloat' },
  TelescopeBorder       = { link = 'FloatBorder' },
  TelescopePromptNormal = { bg = c.prompt },
  TelescopePromptBorder = { fg = c.prompt, bg = c.prompt },

  TelescopeTitle        = { },
  TelescopePreviewTitle = { fg = c.red,     bold = true, reverse = true },
  TelescopePromptTitle  = { fg = c.green,   bold = true, reverse = true },

  TelescopeSelection    = { bg = c.cursor_line },

  -- Treesitter Context
  TreesitterContext = { bg = c.gray1 },

  -- Ufo fold
  UfoCursorFoldedLine = { bg = c.cursor_line, bold = true },

  -- Indent blankline
  IblIndent = { fg = c.gray1 },

  -- Fzf-Lua
  FzfLuatitle   = { fg = c.white,   bg = c.float_bg },

  -- Cmp
  CmpItemAbbrMatch = { fg = c.blue },
  CmpItemKind      = { fg = c.cyan },
  CmpItemMenu      = { fg = c.g4 },

  -- Dashboard
  DashboardHeader   = { fg = c.blue },
  DashboardFooter   = {},
  ---- General
  DashboardProjectTitle     = { fg = c.green },
  DashboardProjectTitleIcon = { fg = c.green },
  DashboardProjectIcon      = { fg = c.green },
  DashboardMruTitle         = { fg = c.green },
  DashboardMruIcon          = { fg = c.green },
  DashboardFiles            = { fg = c.gray8 },
  -- for doom theme
  DashboardIcon     = { fg = c.green },
  DashboardDesc     = { fg = c.green },
  DashboardKey      = { fg = c.red },

  -- Neorg
  -- ['@neorg.links.description'] = { underline = true},

  ['@neorg.headings.1.prefix'] = { fg = c.magenta, bold = true},
  ['@neorg.headings.1.title']  = { fg = c.magenta, bold = true},

  ['@neorg.tags.ranged_verbatim.end']             = { fg = c.neorg_tags_ranver_name },
  ['@neorg.tags.ranged_verbatim.begin']           = { fg = c.neorg_tags_ranver_name },
  ['@neorg.tags.ranged_verbatim.name']            = { fg = c.neorg_tags_ranver_name },
  ['@neorg.tags.ranged_verbatim.name.word']       = { fg = c.neorg_tags_ranver_name },
  ['@neorg.tags.ranged_verbatim.name.delimiter']  = { fg = c.neorg_tags_ranver_deli },
  ['@neorg.tags.ranged_verbatim.parameters.word'] = { fg = c.neorg_tags_ranver_para },

  -- Headline
  Headline           = { bg = util.blend(c.green, c.bg, 0.2) },
  CodeBlock          = { bg = c.gray0 },
  Dash               = { fg = c.cyan,             bold = true },

  -- Flash
  FlashLabel         = { bg = c.yellow, fg = c.black, bold = true },

  LeapMatch          = { fg = c.magenta },
  LeapLabelPrimary   = { bg = c.magenta,  fg = c.black },
  LeapLabelSecondary = { bg = c.blue,     fg = c.black },
  -- LeapLabelSelected  = { },
  -- LeapBackdrop       = { },

  EyelinerPrimary    = { bold = true },
  EyelinerSecondary  = { underline = true },
  -- EyelinerPrimary    = { underline = true,  bold = true },
  -- EyelinerSecondary  = { underline = true },

  IlluminatedWordText  = { bg = c.gray1 },
  IlluminatedWordRead  = { link = 'IlluminatedWordText' },
  IlluminatedWordWrite = { link = 'IlluminatedWordText' },

  -- dapui

  -- DapUINormal                          = { link = 'Normal' },
  -- DapUIVariable                        = { link = 'Normal' },
  -- DapUIEndofBuffer                     = { link = 'EndofBuffer' },

  DapUIScope                           = { fg = c.magenta, bold = true },

  DapUIType                            = { fg = c.cyan },
  DapUIValue                           = { link = 'Normal' },
  DapUIModifiedValue                   = { fg = c.cyan, bold = true },
  DapUIDecoration                      = { fg = c.cyan },
  DapUIThread                          = { fg = c.green },
  DapUIStoppedThread                   = { fg = c.magenta },
  DapUIFrameName                       = { link = 'Normal' },
  DapUISource                          = { fg = c.cyan },
  DapUILineNumber                      = { fg = c.cyan },
  DapUIFloatNormal                     = { link = 'NormalFloat' },
  DapUIFloatBorder                     = { link = 'FloatBorder' },
  DapUICurrentFrameName                = { link = 'DapUIBreakpointsCurrentLine' },

  DapUIWatchesEmpty                    = { fg = c.red },
  DapUIWatchesValue                    = { fg = c.green },
  DapUIWatchesError                    = { fg = c.red },

  DapUIBreakpointsPath                 = { fg = c.magenta, bold = true },
  DapUIBreakpointsInfo                 = { fg = c.green },
  DapUIBreakpointsCurrentLine          = { fg = c.green, bold = true },
  DapUIBreakpointsLine                 = { link = 'DapUILineNumber' },
  DapUIBreakpointsDisabledLine         = { fg = '#424242' },

  DapUIStepOver                        = { fg = c.cyan },
  DapUIStepInto                        = { fg = c.cyan },
  DapUIStepBack                        = { fg = c.cyan },
  DapUIStepOut                         = { fg = c.cyan },
  DapUIStop                            = { fg = c.red },
  DapUIPlayPause                       = { fg = c.green },
  DapUIRestart                         = { fg = c.green },
  DapUIUnavailable                     = { fg = c.gray3 },
  DapUIWinSelect                       = { fg = c.cyan, bold = true },

}
