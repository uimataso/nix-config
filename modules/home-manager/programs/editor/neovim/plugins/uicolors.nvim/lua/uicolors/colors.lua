local util = require('uicolors.util')

-- https://ok-color-picker.netlify.app
-- Saturation: 20%
-- Lightness: 65%

-- https://coolors.co/161616-ababab-db988d-aa9c86-94a38d-86a5a6-8aa1b2-b49599

local colors = {
  black = '#161616', -- 0 0 10
  white = '#ababab', -- 0 0 70
  red = '#bf918c', -- 25 30 65
  yellow = '#aa9c86', -- 80 20 65
  green = '#94a38d', -- 135 20 65
  cyan = '#86a5a6', -- 200 20 65
  blue = '#8aa1b2', -- 240 20 65
  magenta = '#b49599', -- 10 20 65
}

function colors:gray(level)
  -- between black and white
  return util.blend(self.white, self.black, level)
end

-- colors.none = 'NONE'
colors.none = colors.black
colors.fg = colors.white
colors.bg = colors.black
colors.bg_float = colors:gray(0.05)

colors.bg_cursor_line = colors:gray(0.1)
colors.bg_fold = colors:gray(0.135)
colors.bg_qf_select = colors:gray(0.135)
colors.bg_visual = colors:gray(0.2)
colors.border = colors:gray(0.3)
colors.status_line = colors:gray(0.75)
colors.search = colors.yellow

colors.error = colors.red
colors.warning = colors.yellow
colors.info = colors.cyan
colors.hint = colors:gray(0.75)
colors.guide = colors.green
colors.todo = colors.green

colors.non_text = colors:gray(0.5)
colors.comment = colors:gray(0.5)
colors.title = colors.magenta

colors.diff = {
  add = colors.green,
  change = colors.blue,
  delete = colors.red,
}

-- bg          -> 10
-- float bg    -> 13
-- cursor line -> 17
-- visual      -> 20
-- fold        -> 23
-- border      -> 30
-- nontext     -> 40
-- line number -> 40
-- comment     -> 40

colors.gray0 = util.blend(colors.white, colors.black, 0.05)
colors.gray1 = util.blend(colors.white, colors.black, 0.1)
colors.gray2 = util.blend(colors.white, colors.black, 0.2)
colors.gray3 = util.blend(colors.white, colors.black, 0.3)
colors.gray4 = util.blend(colors.white, colors.black, 0.4)
colors.gray5 = util.blend(colors.white, colors.black, 0.5)
colors.gray6 = util.blend(colors.white, colors.black, 0.6)
colors.gray7 = util.blend(colors.white, colors.black, 0.7)
colors.gray8 = util.blend(colors.white, colors.black, 0.8)
colors.gray9 = util.blend(colors.white, colors.black, 0.9)

-- UI --
colors.cursor_line = colors.gray1
colors.nontext = colors.gray4
colors.float_bg = colors.gray0

-- Syntax --
-- colors.comment = colors.gray5

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

colors.diff_add = util.blend('#00ff00', colors.black, 0.15)
colors.diff_delete = util.blend('#ff0000', colors.black, 0.15)

colors.reference = util.blend(colors.cyan, colors.white, 0.6)

-- Plugin --
colors.prompt = colors.gray1

colors.neorg_tags_ranver_name = util.blend(colors.magenta, colors.black, 0.4)
colors.neorg_tags_ranver_deli = util.blend(colors.punctuation, colors.black, 0.4)
colors.neorg_tags_ranver_para = util.blend(colors.blue, colors.black, 0.4)

return colors
