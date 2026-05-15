local M = {}

-- :h group-name

M.get = function(c)
  return {
    -- helper groups
    Literal = { fg = c.syntax.constant },
    Punctuation = { fg = c.syntax.punctuation },

    Comment = { fg = c.syntax.comment },

    Constant = { fg = c.syntax.constant },
    String = 'Literal',
    Character = 'Literal',
    Number = 'Literal',
    Boolean = 'Literal',
    Float = 'Literal',

    Identifier = { fg = c.syntax.variable },
    Function = { fg = c.syntax.fn },

    Statement = 'Keyword',
    Conditional = 'Keyword',
    Repeat = 'Keyword',
    Label = 'Keyword',
    Operator = 'Keyword',
    Keyword = { fg = c.syntax.keyword },
    Exception = 'Keyword',

    PreProc = 'Keyword',
    Include = 'Keyword',
    Define = 'Keyword',
    Macro = 'Keyword',
    PreCondit = 'Keyword',

    Type = { fg = c.syntax.type },
    StorageClass = 'Keyword',
    Structure = 'Keyword',
    Typedef = 'Keyword',

    Special = 'Punctuation',
    SpecialChar = 'Punctuation',
    Tag = { fg = c.markup.link },
    Delimiter = 'Punctuation',
    SpecialComment = 'Comment',
    Debug = 'Keyword',

    Underlined = { underline = true },

    Ignore = {},

    Error = { fg = c.diag.error },

    Todo = { fg = c.diag.todo, bold = true },

    Added = 'DiffAdd',
    Changed = 'DiffChange',
    Removed = 'DiffDelete',
  }
end

return M
