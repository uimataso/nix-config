local util = require('luasnip-util')

local function mathzone()
  -- return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
  return true
end

return {

  s({
    trig = 'doc',
    name = 'documentclass',
    dscr = 'Create a documentclass',
  }, {
    t('\\documentclass{article}')
  }),

  s({
    trig = 'beg',
    name = 'environments',
    dscr = 'Create a begin/end environments',
  }, fmta([[
      \begin{<>}
      <>
      \end{<>}
    ]], {
    i(1, 'document'), util.input(2), rep(1),
    -- i(1, 'document'), t('\t'), r(2), rep(1),
  })
  ),

  s({
    trig = 'lr',
    name = 'left right',
    dscr = 'left right',
  }, {
    c(1, {
      sn(nil, { t('\\left( '), util.input(1), t(' \\right)') }),
      sn(nil, { t('\\left{ '), util.input(1), t(' \\right}') }),
      sn(nil, { t('\\left[ '), util.input(1), t(' \\right]') }),
    }),
  }, {
    condition = mathzone,
    show_condition = mathzone
  }),


}, {

  -- s({
  --   trig = '(%a)(%d)',
  --   regTrig = true,
  --   name = 'Auto subscript',
  --   dscr = 'Auto adding underscore if typing a digit after letters',
  -- }, { f(function(_, snip)
  --     return snip.captures[1] .. '_' .. snip.captures[2]
  --   end),
  -- }, {
  --   condition = mathzone,
  -- }),

  s({
    -- trig = '([%a%}]+)([_^])([%a%d][%a%d]+)([%s_^])',
    trig = '([%a%}]+)([_^])(%w%w+)([%s_^])',
    regTrig = true,
    name = 'auto sub/superscript',
    dscr = 'Auto adding surround curly brace on multi chars sub/superscript',
  }, { f(function(_, snip)
    return snip.captures[1] .. snip.captures[2] .. '{' .. snip.captures[3] .. '}' .. snip.captures[4]
  end),
  }, {
    condition = mathzone,
  }),


  postfix({
    trig = '.hat ',
    name = 'auto hat',
    dscr = '',
  }, {
    l('\\hat{' .. l.POSTFIX_MATCH .. '} ')
  }, {
    condition = mathzone,
  }),

}
