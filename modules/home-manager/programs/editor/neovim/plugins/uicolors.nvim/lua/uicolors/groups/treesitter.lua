local M = {}

M.url = 'https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights'

M.get = function(c)
  return {
    -- Identifiers
    ['@variable'] = { fg = c.syntax.variable },
    ['@variable.builtin'] = '@variable',
    ['@variable.parameter'] = '@variable',
    ['@variable.parameter.builtin'] = '@variable',
    ['@variable.member'] = '@variable',

    ['@constant'] = { fg = c.syntax.variable },
    ['@constant.builtin'] = '@constant',
    ['@constant.macro'] = '@function.macro',

    ['@module'] = { fg = c.syntax.module },
    ['@module.builtin'] = '@module',
    ['@label'] = { fg = c.syntax.label },

    -- Literals
    ['@string'] = { fg = c.syntax.literal },
    ['@string.documentation'] = '@string',
    ['@string.regexp'] = { fg = c.red },
    ['@string.escape'] = { fg = c.red },
    ['@string.special'] = '@string',
    ['@string.special.symbol'] = '@string',
    ['@string.special.url'] = '@string',
    ['@string.special.path'] = '@string',

    ['@character'] = '@string',
    ['@character.special'] = '@string.escape',

    ['@boolean'] = { fg = c.syntax.literal },
    ['@number'] = { fg = c.syntax.literal },
    ['@number.float'] = '@number',

    -- Types
    ['@type'] = { fg = c.syntax.type },
    ['@type.builtin'] = '@type',
    ['@type.definition'] = '@keyword',

    ['@attribute'] = '@label',
    ['@attribute.builtin'] = '@label',
    ['@property'] = '@variable.member',

    -- Functions
    ['@function'] = { fg = c.syntax.fn },
    ['@function.builtin'] = '@function',
    ['@function.call'] = '@function',
    ['@function.macro'] = '@function',

    ['@function.method'] = '@function',
    ['@function.method.call'] = '@function.call',

    ['@constructor'] = '@function',
    ['@operator'] = { fg = c.syntax.operator },

    -- Keywords
    ['@keyword'] = { fg = c.syntax.keyword, bold = true },
    ['@keyword.coroutine'] = '@keyword',
    ['@keyword.function'] = '@keyword',
    ['@keyword.operator'] = '@keyword',
    ['@keyword.import'] = '@keyword',
    ['@keyword.type'] = '@keyword',
    ['@keyword.modifier'] = '@keyword',
    ['@keyword.repeat'] = '@keyword',
    ['@keyword.return'] = '@keyword',
    ['@keyword.debug'] = '@keyword',
    ['@keyword.exception'] = '@keyword',

    ['@keyword.conditional'] = '@keyword',
    ['@keyword.conditional.ternary'] = '@keyword',

    ['@keyword.directive'] = '@keyword',
    ['@keyword.directive.define'] = '@keyword',

    -- Punctuation
    ['@punctuation.delimiter'] = { fg = c.syntax.punctuation },
    ['@punctuation.bracket'] = { fg = c.syntax.punctuation },
    ['@punctuation.special'] = { fg = c.syntax.punctuation },

    -- Comments
    ['@comment'] = { fg = c.syntax.comment },
    ['@comment.documentation'] = '@comment',

    ['@comment.error'] = { fg = c.error },
    ['@comment.warning'] = { fg = c.warning },
    ['@comment.todo'] = { fg = c.todo },
    ['@comment.note'] = { fg = c.note },

    -- Markup
    ['@markup.strong'] = { bold = true },
    ['@markup.italic'] = { italic = true },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.underline'] = { underline = true },

    ['@markup.heading'] = { fg = c.title, bold = true },
    ['@markup.heading.1'] = { fg = c.markup.title1, bold = true },
    ['@markup.heading.2'] = { fg = c.markup.title2, bold = true },
    ['@markup.heading.3'] = { fg = c.markup.title3, bold = true },
    ['@markup.heading.4'] = { fg = c.markup.title4, bold = true },
    ['@markup.heading.5'] = { fg = c.markup.title5, bold = true },
    ['@markup.heading.6'] = { fg = c.markup.title6, bold = true },

    ['@markup.quote'] = { fg = c.markup.quote },
    ['@markup.math'] = { fg = c.markup.quote },

    ['@markup.link'] = { fg = c.markup.link, sp = c.markup.link_sp, underline = true },
    ['@markup.link.label'] = { sp = c.markup.link_sp, underline = true },
    ['@markup.link.url'] = { fg = c.markup.link, sp = c.markup.link_sp, underline = true },

    ['@markup.raw'] = { fg = c.markup.quote, bg = c.bg_quote },
    ['@markup.raw.block'] = { fg = c.markup.quote, bg = c.bg_quote },

    ['@markup.list'] = { fg = c.markup.bullet, bold = true },
    ['@markup.list.checked'] = '@markup.list',
    ['@markup.list.unchecked'] = { fg = c.fg, bold = true },

    ['@diff.plus'] = 'DiffAdd',
    ['@diff.minus'] = 'DiffDelete',
    ['@diff.delta'] = 'DiffChange',

    ['@tag'] = { fg = c.syntax.tag, bold = true },
    ['@tag.builtin'] = '@tag',
    ['@tag.attribute'] = '@variable',
    ['@tag.delimiter'] = '@punctuation.delimiter',

    -- Non-highlighting captures
    ['@none'] = 'NonText',
    -- ['@conceal']

    -- ['@spell'] = {},
    -- ['@nospell'] = {},

    -- TODO: make injected rust code in document less highlighted
    ['@lsp.mod.intraDocLink.rust'] = { fg = c.base04 },

    rustModPath = '@module', -- somehow this got links to '@keyword'
  }
end

return M

-- TODO: see :h lsp-semantic-highlight
-- @lsp           xxx cleared
-- @lsp.type.class xxx links to @type
-- @lsp.type.comment xxx links to @comment
-- @lsp.type.decorator xxx links to @attribute
-- @lsp.type.enum xxx links to @type
-- @lsp.type.enumMember xxx links to @constant
-- @lsp.type.event xxx links to @type
-- @lsp.type.function xxx links to @function
-- @lsp.type.interface xxx links to @type
-- @lsp.type.keyword xxx links to @keyword
-- @lsp.type.macro xxx links to @constant.macro
-- @lsp.type.method xxx links to @function.method
-- @lsp.type.modifier xxx links to @type.qualifier
-- @lsp.type.namespace xxx links to @module
-- @lsp.type.number xxx links to @number
-- @lsp.type.operator xxx links to @operator
-- @lsp.type.parameter xxx links to @variable.parameter
-- @lsp.type.property xxx links to @property
-- @lsp.type.regexp xxx links to @string.regexp
-- @lsp.type.string xxx links to @string
-- @lsp.type.struct xxx links to @type
-- @lsp.type.type xxx links to @type
-- @lsp.type.typeParameter xxx links to @type.definition
-- @lsp.type.variable xxx links to @variable
-- @lsp.mod.deprecated xxx links to DiagnosticDeprecated
