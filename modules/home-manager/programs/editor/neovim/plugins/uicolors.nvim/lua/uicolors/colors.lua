local util = require('uicolors.util')

-- https://ok-color-picker.netlify.app
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

colors.none = 'NONE'
-- colors.none = colors.black
colors.fg = colors.white
colors.bg = colors.black
colors.bg_float = colors:gray(0.05)

colors.bg_cursor_line = colors:gray(0.1)
colors.bg_fold = colors:gray(0.135)
colors.bg_qf_select = colors:gray(0.135)
colors.bg_prompt = colors:gray(0.135)
colors.bg_visual = colors:gray(0.2)
colors.border = colors:gray(0.3)
colors.status_line = colors:gray(0.75)
colors.search = colors.yellow
colors.non_text = colors:gray(0.5)
colors.title = colors.magenta

colors.syntax = {
  comment = colors:gray(0.5),
  literal = colors.yellow,
  variable = colors.white,
  fn = colors.white,
  type = colors:gray(0.8),
  keyword = colors.magenta,

  punctuation = colors:gray(0.5),
  operator = colors:gray(0.7),
  module = colors.white,
  label = colors.magenta,
  tag = colors.white,
}

colors.markup = {
  title1 = colors.title,
  title2 = colors.blue,
  title3 = colors.cyan,
  title4 = colors.title,
  title5 = colors.blue,
  title6 = colors.cyan,

  link = colors:gray(0.5),
  url = colors:gray(0.7),
  quote = colors:gray(0.8),
  bullet = colors:gray(0.6),
}

colors.error = colors.red
colors.warning = colors.yellow
colors.info = colors.cyan
colors.hint = colors:gray(0.75)
colors.ok = colors.green
colors.guide = colors.green
colors.todo = colors.green
colors.unused = colors:gray(0.75)

colors.diff = {
  add = colors.green,
  change = colors.blue,
  delete = colors.red,
  text = colors:gray(0.5),
}

return colors
