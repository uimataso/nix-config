local util = require('luasnip-util')

local function for_node(jump)
  return c(jump, {
    fmta('for <> in <>', {
      r(1, 'i', i(nil, 'i')), r(2, 'iter', i(nil, 'iter')) }),
    fmta('for <> in range(<>)', {
      r(1, 'i'), r(2, 'iter') }),
    fmta('for <>, <> in enumerate(<>)', {
      r(1, 'i'), r(2, 'j', i(nil, 'j')), r(3, 'iter') }),
    fmta('for <>, <> in zip(<>, <>)', {
      r(1, 'i'), r(2, 'j'), r(3, 'iter'), r(4, 'sec_iter', i(nil, 'sec_iter')) }),
  })
end


return {

  s({
    trig = 'fn',
    name = 'function',
    dscr = 'Create a function',
  }, {
    t('def '), i(1, 'name'), t({ ':', '' }), util.input(2, { indent = 1 }),
  }),

  s({
    trig = 'if',
    name = 'if',
    dscr = 'Create a if',
  }, {
    t('if '), i(1, 'cond'), t({ ':', '' }), util.input(2, { indent = 1 }),
  }),

  s({
    trig = 'for',
    name = 'for',
    dscr = 'Create a for loop',
  }, {
    for_node(1), t({ ':', '' }), util.input(2, { indent = 1 }),
  }),

  s({
    trig = 'wh',
    name = 'while',
    dscr = 'Create a while',
  }, {
    t('while '), i(1, 'cond'), t({ ':', '' }), util.input(2, { indent = 1 }),
  }),

  s({
    trig = 'main',
    name = 'If main',
    dscr = 'Create if name == main snippet',
  }, {
    t({ 'def main():', '' }), util.input(1, { indent = 1 }),
    t({ '', '', "if __name__ == '__main__':", '\tmain()' })
  }),

  s({
    trig = 'lc',
    name = 'list comprehension',
    dscr = 'Create a list comprehension',
  }, {
    t('['),
    i(1, 'exp'), t(' '), for_node(2),
    c(3, { t(''), sn(nil, { t(' if '), i(1, 'cond') }), }),
    t(']'),
  }),

  s({
    trig = 'dc',
    name = 'dictionary comprehension',
    dscr = 'Create a dictionary comprehension',
  }, {
    t('{'),
    i(1, 'key'), t(': '), i(2, 'value'), t(' '), for_node(3),
    c(4, { t(''), sn(nil, { t(' if '), i(1, 'cond') }), }),
    t('}'),
  }),

}
