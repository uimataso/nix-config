local util = require('luasnip-util')

return {

  s({
    trig = 'link',
    name = 'link',
    dscr = 'Insert a link',
  }, {
    t('['), util.input(1, { default = 'Text' }), t(']('), i(2, 'URL'), t(')'),
  }),

  s({
    trig = 'img',
    name = 'image',
    dscr = 'Insert a image',
  }, {
    t('!['), util.input(1, { default = 'Text' }), t(']('), i(2, 'URL'), t(')'),
  }),

}
