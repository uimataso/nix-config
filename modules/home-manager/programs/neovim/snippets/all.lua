local util = require('luasnip-util')

return {

  s({
    trig = 'vfold',
    name = '',
    dscr = '',
  }, {
    t('vim:foldmethod=marker:foldlevel=0')
  }),

  s("pc", {
    c(1, {
      sn(nil, { t("("), util.input(1), t(")") }),
      sn(nil, { t("["), util.input(1), t("]") }),
      sn(nil, { t("{"), util.input(1), t("}") }),
    }),
  })

}
