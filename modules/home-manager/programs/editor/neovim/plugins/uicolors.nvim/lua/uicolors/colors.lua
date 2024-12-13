local util = require('uicolors.util')

local colors = {
  black = '#161616',
  red = '#c68586',
  green = '#86a586',
  yellow = '#d5be95',
  blue = '#83a0af',
  magenta = '#d8afad',
  cyan = '#8caeaf',
  white = '#bcbcbc',
}

colors.background = 'NONE' -- or c.bg
colors.bg = colors.black
colors.fg = colors.white

colors.gray0 = util.blend(colors.fg, colors.bg, 0.05)
colors.gray1 = util.blend(colors.fg, colors.bg, 0.1)
colors.gray2 = util.blend(colors.fg, colors.bg, 0.2)
colors.gray3 = util.blend(colors.fg, colors.bg, 0.3)
colors.gray4 = util.blend(colors.fg, colors.bg, 0.4)
colors.gray5 = util.blend(colors.fg, colors.bg, 0.5)
colors.gray6 = util.blend(colors.fg, colors.bg, 0.6)
colors.gray7 = util.blend(colors.fg, colors.bg, 0.7)
colors.gray8 = util.blend(colors.fg, colors.bg, 0.8)
colors.gray9 = util.blend(colors.fg, colors.bg, 0.9)

-- UI --
colors.cursor_line = colors.gray1
colors.nontext = colors.gray4
colors.float_bg = colors.gray0

-- Syntax --
colors.comment = colors.gray5

colors.preproc = colors.white
colors.keyword = colors.magenta
colors.func = colors.white
colors.type = colors.white
colors.field = colors.white
colors.namespace = colors.white
colors.punctuation = colors.gray6

colors.variable = colors.white
colors.constant = colors.white
colors.string = colors.yellow
colors.value = colors.yellow

colors.uri = colors.cyan

colors.diff_add = util.blend('#00ff00', colors.bg, 0.15)
colors.diff_delete = util.blend('#ff0000', colors.bg, 0.15)

colors.reference = util.blend(colors.cyan, colors.fg, 0.6)

-- Plugin --
colors.prompt = colors.gray1

colors.neorg_tags_ranver_name = util.blend(colors.magenta, colors.bg, 0.4)
colors.neorg_tags_ranver_deli = util.blend(colors.punctuation, colors.bg, 0.4)
colors.neorg_tags_ranver_para = util.blend(colors.blue, colors.bg, 0.4)

return colors
