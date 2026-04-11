local M = {}

-- :h treesitter-highlight

M.get = function(c)
  return {
    ['@variable'] = { fg = c.syntax.variable },
    ['@variable.builtin'] = '@variable',
    ['@variable.parameter'] = '@variable',
    ['@variable.parameter.builtin'] = '@variable',
    ['@variable.member'] = '@variable',

    ['@constant'] = { fg = c.syntax.constant },
    ['@constant.builtin'] = '@constant',
    ['@constant.macro'] = '@constant',

    ['@module'] = { fg = c.syntax.module },
    ['@module.builtin'] = '@module',
    ['@label'] = { fg = c.syntax.label },

    ['@string'] = { fg = c.syntax.literal },
    ['@string.documentation'] = '@string',
    ['@string.regexp'] = { fg = c.red },
    ['@string.escape'] = { fg = c.red },
    ['@string.special'] = '@string',
    ['@string.special.symbol'] = '@string',
    ['@string.special.path'] = '@string',
    ['@string.special.url'] = '@string',

    ['@character'] = '@string',
    ['@character.special'] = '@string.escape',

    ['@boolean'] = { fg = c.syntax.literal },
    ['@number'] = { fg = c.syntax.literal },
    ['@number.float'] = '@number',

    ['@type'] = { fg = c.syntax.type },
    ['@type.builtin'] = '@type',
    ['@type.definition'] = '@type',

    ['@attribute'] = '@label',
    ['@attribute.builtin'] = '@label',
    ['@property'] = '@variable.member',

    ['@function'] = { fg = c.syntax.fn },
    ['@function.builtin'] = '@function',
    ['@function.call'] = '@function',
    ['@function.macro'] = '@function',

    ['@function.method'] = '@function',
    ['@function.method.call'] = '@function.call',

    ['@constructor'] = '@function',
    ['@operator'] = { fg = c.syntax.operator },

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

    ['@punctuation'] = { fg = c.syntax.punctuation },
    ['@punctuation.delimiter'] = '@punctuation',
    ['@punctuation.bracket'] = '@punctuation',
    ['@punctuation.special'] = '@punctuation',

    ['@comment'] = { fg = c.syntax.comment },
    ['@comment.documentation'] = '@comment',

    ['@comment.error'] = { fg = c.diag.error, bold = true },
    ['@comment.warning'] = { fg = c.diag.warn, bold = true },
    ['@comment.todo'] = { fg = c.diag.todo, bold = true },
    ['@comment.note'] = { fg = c.diag.note, bold = true },

    ['@markup.strong'] = { bold = true },
    ['@markup.italic'] = { italic = true },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.underline'] = { underline = true },

    ['@markup.heading'] = { fg = c.markup.title, bold = true },
    ['@markup.heading.1'] = '@markup.heading',
    ['@markup.heading.2'] = '@markup.heading',
    ['@markup.heading.3'] = '@markup.heading',
    ['@markup.heading.4'] = '@markup.heading',
    ['@markup.heading.5'] = '@markup.heading',
    ['@markup.heading.6'] = '@markup.heading',

    ['@markup.quote'] = { fg = c.markup.quote },
    ['@markup.math'] = { fg = c.markup.quote },

    ['@markup.link'] = { fg = c.markup.link, sp = c.markup.link_sp, underline = true },
    ['@markup.link.label'] = { sp = c.markup.link_sp, underline = true },
    ['@markup.link.url'] = { fg = c.markup.link, sp = c.markup.link_sp, underline = true },

    ['@markup.raw'] = { fg = c.markup.raw },
    ['@markup.raw.block'] = { fg = c.markup.raw },

    ['@markup.list'] = { fg = c.markup.bullet, bold = true },
    ['@markup.list.checked'] = '@markup.list',
    ['@markup.list.unchecked'] = '@markup.list',

    ['@diff.plus'] = 'DiffAdd',
    ['@diff.minus'] = 'DiffDelete',
    ['@diff.delta'] = 'DiffChange',

    ['@tag'] = { fg = c.syntax.tag, bold = true },
    ['@tag.builtin'] = '@tag',
    ['@tag.attribute'] = '@property',
    ['@tag.delimiter'] = '@punctuation.delimiter',
  }
end

return M
