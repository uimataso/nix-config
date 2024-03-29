local util = require('luasnip-util')

local function cond_node(jump)
  return c(jump, {
    r(1, 'cond', i(nil, 'cond')),
    sn(nil, { t('[ '), r(1, 'cond'), t(' ]') })
  })
end

return {

  s({
    trig = 'fn',
    name = 'function',
    dscr = 'Create a function',
  }, {
    -- i(1, 'name'), t({'() {', ''}), util.input(2, {indent=1}), t({'', '}'}),
    i(1, 'name'), t({ '() {', '' }), util.input(2, { indent = 1 }), t({ '', '}' }),
  }),

  s({
    trig = 'if',
    name = 'if',
    dscr = 'Create a if',
  }, {
    t('if '), cond_node(1), t({ '; then', '' }),
    util.input(2, { indent = 1 }),
    t({ '', 'fi' })
  }),

  s({
    trig = 'for',
    name = 'for',
    dscr = 'Create a for loop',
  }, {
    t('for '), i(1, 'i'), t(' in '), i(2, 'list'), t({ '; do', '' }),
    util.input(3, { indent = 1 }),
    t({ '', 'done' })
  }),

  s({
    trig = 'wh',
    name = 'while',
    dscr = 'Create a while loop',
  }, {
    t('while '), cond_node(1), t({ '; do', '' }),
    util.input(2, { indent = 1 }),
    t({ '', 'done' })
  }),

  s({
    trig = 'case',
    name = 'case',
    dscr = 'Create a case',
  }, {
    t('case '), i(1, '$i'), t({ ' in', '' }),
    t('\t'), i(2, "'--'"), t(') '), i(3, 'break'), t(' ;;'),
    t({ '', 'esac' })
  }),

  s({
    trig = 'ty',
    name = 'if not runnable',
    dscr = 'Use type to determine the command is runnable',
  }, {
    c(1, {
      sn(nil, {
        t('type '), i(1, 'cmd'), t(' >/dev/null '),
        c(2, { t('&&'), t('||') }), t(' '), util.input(3),
      }),
      sn(nil, {
        t('if type '), i(1, 'cmd'), t({ ' >/dev/null; then', '\t' }),
        util.input(2), t({ '', 'fi' }),
      }),
    }),
  }),

  s({
    trig = 'rl',
    name = 'while read line',
    dscr = 'Processes the file with read',
  }, {
    t({ 'while read -r line; do', '' }), util.input(2, { indent = 1 }),
    t({ '', 'done <' }), i(1, '"$file"')
  }),

  s({
    trig = 'nu',
    name = 'no output',
    dscr = '',
  }, {
    t('>/dev/null'), c(1, { t(''), t(' 2>&1') })
  }),

  -- TODO:
  -- start template
  -- getopt
  -- temp file
  -- cat << EOF
  -- clean trap
  -- "$()"

}
