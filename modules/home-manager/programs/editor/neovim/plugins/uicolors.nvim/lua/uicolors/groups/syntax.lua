local M = {}

-- see :h group-name

M.get = function(c)
  return {
    Comment = '@comment',

    Constant = '@constant',
    String = '@string',
    Character = '@character',
    Number = '@number',
    Boolean = '@boolean',
    Float = '@number.float',

    Identifier = '@variable',
    Function = '@function',

    Statement = '@keyword',
    Conditional = '@keyword.conditional',
    Repeat = '@keyword.repeat',
    Label = '@label',
    Operator = '@keyword.operator',
    Keyword = '@keyword',
    Exception = '@keyword.exception',

    PreProc = '@keyword.directive',
    Include = '@keyword.import',
    Define = '@keyword.directive.define',
    Macro = '@keyword.directive.define',
    PreCondit = '@keyword.directive',

    Type = '@type',
    StorageClass = '@keyword.modifier',
    Structure = '@keyword.type',
    Typedef = '@type.definition',

    Special = '@punctuation.special',
    SpecialChar = '@character.special',
    Tag = '@markup.link.label',
    Delimiter = '@punctuation.delimiter',
    SpecialComment = '@comment.note',
    Debug = '@keyword.debug',

    Underlined = { underline = true },

    Ignore = {},

    Error = { fg = c.error },

    Todo = '@comment.todo',

    Added = 'DiffAdd',
    Changed = 'DiffChange',
    Removed = 'DiffDelete',
  }
end

return M
