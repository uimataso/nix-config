local c = require('uicolors.colors')

return {
  -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights

  -- Misc --
  ['@comment'] = { fg = c.comment },
  ['@error'] = {},
  ['@none'] = {},
  ['@preproc'] = { fg = c.preproc },
  ['@define'] = { link = '@preproc' },
  ['@operator'] = { fg = c.fg },

  -- Punctuation --
  ['@punctuation'] = { fg = c.punctuation },
  ['@punctuation.delimiter'] = { link = '@punctuation' },
  ['@punctuation.bracket'] = { link = '@punctuation' },
  ['@punctuation.special'] = { link = '@punctuation' },

  -- Literals --
  ['@string'] = { fg = c.string },
  ['@string.regex'] = { link = '@string' },
  ['@string.escape'] = { link = '@string.special' },
  ['@string.special'] = { fg = c.red },

  ['@character'] = { link = '@string' },
  ['@character.special'] = { link = '@string.special' },

  ['@boolean'] = { fg = c.value },
  ['@number'] = { link = '@boolean' },
  ['@float'] = { link = '@boolean' },

  -- Functions --
  ['@function'] = { fg = c.func },
  ['@function.builtin'] = { fg = c.func, bold = true },
  ['@function.call'] = { link = '@function' },
  ['@function.macro'] = { link = '@function' },

  ['@method'] = { link = '@functin' },
  ['@method.call'] = { link = '@method' },

  ['@constructor'] = {},
  ['@parameter'] = { link = '@variable' },
  ['@parameter.reference'] = { fg = c.variable, bold = true },

  -- Keywords --
  ['@keyword'] = { fg = c.keyword },
  ['@keyword.function'] = { fg = c.keyword, bold = true },
  ['@keyword.operator'] = { fg = c.white, bold = true },
  ['@keyword.return'] = { link = '@preproc' },

  ['@conditional'] = { fg = c.keyword, bold = true },
  ['@repeat'] = { fg = c.keyword, bold = true },
  ['@debug'] = { link = '@preproc' },
  ['@label'] = { link = '@preproc' },
  ['@include'] = { link = '@preproc' },
  ['@exception'] = { link = '@preproc' },

  -- Types --
  ['@type'] = { fg = c.type },
  ['@type.builtin'] = { fg = c.type, bold = true },
  ['@type.definition'] = { link = '@preproc' },
  ['@type.qualifier'] = { link = '@type' },

  ['@storageclass'] = { fg = c.cyan },
  ['@attribute'] = { fg = c.cyan },
  ['@field'] = { fg = c.field },
  ['@property'] = { link = '@field' },

  -- Identifiers --
  ['@variable'] = { fg = c.variable },
  ['@variable.builtin'] = { fg = c.variable, bold = true },

  ['@constant'] = { fg = c.constant },
  ['@constant.builtin'] = { fg = c.constant, bold = true },
  ['@constant.macro'] = { link = '@preproc' },

  ['@namespace'] = { fg = c.namespace },
  ['@symbol'] = {},

  -- Text --
  ['@text'] = {},
  ['@text.strong'] = { bold = true },
  ['@text.emphasis'] = { italic = true },
  ['@text.underline'] = { underline = true },
  ['@text.strike'] = { strikethrough = true },
  ['@text.title'] = { link = 'Title' },
  ['@text.literal'] = { bg = c.gray1 },
  ['@text.uri'] = { fg = c.uri, underline = true },
  -- ['@text.math']             = { },
  ['@text.environment'] = { link = '@keyword' },
  ['@text.environment.name'] = { fg = c.blue, bold = true },
  ['@text.reference'] = { fg = c.reference },

  ['@text.todo'] = { fg = c.black, bg = c.cyan, bold = true },
  ['@text.note'] = { link = '@text.todo' },
  ['@text.warning'] = { link = '@text.todo' },
  ['@text.danger'] = { link = '@text.todo' },

  ['@text.diff.add'] = { bg = c.diff_add },
  ['@text.diff.delete'] = { bg = c.diff_delete },

  -- Tags --
  ['@tag'] = { fg = c.cyan },
  ['@tag.attribute'] = { fg = c.gray8 },
  ['@tag.delimiter'] = { fg = c.gray6 },

  -- Conceal --
  -- ['@conceal']               = { },

  -- Spell --
  -- ['@spell']                 = { },

  -- Fix --
  ['@constant.comment'] = { link = '@comment' },

  -- Filetype --
  ['@field.yaml'] = { fg = c.cyan, bold = true },
  ['@label.json'] = { fg = c.cyan, bold = true },

  ['@function.latex'] = { fg = c.cyan },

  -----------------------------
  --  Vanilla Syntax Groups  --
  -----------------------------
  -- links vailla syntax groups to treesitter groups {{{
  Comment = { link = '@comment' },

  Constant = { link = '@constant' },
  String = { link = '@string' },
  Character = { link = '@character' },
  Number = { link = '@number' },
  Boolean = { link = '@boolean' },
  Float = { link = '@float' },

  Identifier = { link = '@variable' },
  Function = { link = '@function' },

  Statement = { link = '@conditional' },
  Conditional = { link = '@conditional' },
  Repeat = { link = '@reqeat' },
  Label = { link = '@label' },
  Operator = { link = '@operator' },
  Keyword = { link = '@keyword' },
  Exception = { link = '@exception' },

  PreProc = { link = '@preproc' },
  Include = { link = '@include' },
  Define = { link = '@define' },
  Macro = { link = '@constant.macro' },
  PreCondit = { link = '@preproc' },

  Type = { link = '@link' },
  StorageClass = { link = '@storageclass' },
  Structure = { link = '@' },
  Typedef = { link = '@type.definition' },

  Special = { link = '@character.special' },
  SpecialChar = { link = '@character.special' },
  Tag = { link = '@tag' },
  Delimiter = { link = '@punctuation.delimiter' },
  SpecialComment = { link = '@comment' },
  Debug = { link = '@debug' },

  Underlined = { link = '@text.underline' },
  Ignore = { link = '@none' },
  Error = { link = '@error' },
  Todo = { link = '@text.todo' },
  --}}}
}
