local util = require('luasnip-util')

return {

  s({
    trig = 'sn',
    name = 'snipets',
    dscr = 'Create a snippet',
  }, fmta([[
    <>({
      trig = '<>',
      <>name = '<>',
      dscr = '<>',
    }, <><>),
    ]], {
    c(1, { i(nil, 's'), i(nil, 'postfix') }),
    i(2, 'Trig'),
    c(3, { t(''), t({ 'regTrig = true,', '\t' }), }),
    i(4, 'Name'),
    i(5, 'Dscr'),
    c(6, {
      sn(nil, { t({ '{', '\t' }), r(1, 'node', i(nil, 'Node')), t({ '', '}' }) }),
      sn(nil, {
        t({ 'fmta([[', '' }),
        t('\t\t'), i(1, 'Text'),
        t({ '', '\t]], {', '' }),
        t('\t'), r(2, 'node'),
        t({ '', '})' }),
      }),
    }),
    c(7, {
      t(''),
      sn(nil, {
        t({ ', {', '\tcondition = ' }), i(1, 'cond'), t({ ',', '}' }),
      }),
    }),
  })
  ),

  s({
    trig = 'fn',
    name = 'function',
    dscr = 'Create a function',
  }, {
    c(1, {
      sn(nil, { t('local function '), r(1, 'name'), t('('), r(2, 'args'), t(')'), }),
      sn(nil, { t('function '), r(1, 'name'), t('('), r(2, 'args'), t(')'), }),
      sn(nil, { t('local '), r(1, 'name'), t(' = function('), r(2, 'args'), t(')') }),
    }),
    t({ '', '' }), util.input(2, { indent = 1 }), t({ '', 'end' })
  }, {
    stored = {
      ['name'] = i(nil, 'name'),
      ['args'] = i(nil),
    }
  }),

  s({
    trig = 'for',
    name = 'for',
    dscr = 'Create a for loop',
  }, {
    c(1, {
      fmta('for <> in <> do', { r(1, 'i'), r(2, 'table') }),
      fmta('for <>, <> in pairs(<>) do', { r(1, 'i'), r(2, 'j'), r(3, 'table') }),
      fmta('for <>, <> in ipairs(<>) do', { r(1, 'i'), r(2, 'j'), r(3, 'table') }),
      fmta('for <>=<>,<> do', { r(1, 'i'), r(2, '0'), r(3, '10') }),
      fmta('for <>=<>,<>,<> do', { r(1, 'i'), r(2, '0'), r(3, '10'), r(4, '2') }),
    }),
    t({ '', '' }), util.input(2, { indent = 1 }),
    t({ '', 'end' })
  }, {
    stored = {
      ['i'] = i(nil, 'i'),
      ['j'] = i(nil, 'j'),
      ['table'] = i(nil, 'table'),
      ['0'] = i(nil, '0'),
      ['10'] = i(nil, '10'),
      ['2'] = i(nil, '2'),
    }
  }),

  s({
    trig = 'wh',
    name = 'while',
    dscr = 'Create a while loop',
  }, {
    t('while '), i(1, 'cond'), t(' do'),
    t({ '', '' }), util.input(2, { indent = 1 }),
    t({ '', 'end' })
  }),

}
