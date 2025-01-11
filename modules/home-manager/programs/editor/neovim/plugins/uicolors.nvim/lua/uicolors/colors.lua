local util = require('uicolors.util')

-- https://ok-color-picker.netlify.app
-- https://coolors.co/161616-ababab-db988d-aa9c86-94a38d-86a5a6-8aa1b2-b49599

local colors = {
  black = '#161616', -- 0 0 10
  -- white = '#ababab', -- 0 0 70
  -- red = '#bf918c', -- 25 30 65
  -- yellow = '#aa9c86', -- 80 20 65
  -- green = '#94a38d', -- 135 20 65
  -- blue = '#8aa1b2', -- 240 20 65
  -- magenta = '#b49599', -- 10 20 65
  white = '#ddc7a1',
  red = '#ea6962', -- 25 30 65
  yellow = '#d8a657', -- 80 20 65
  green = '#a9b665', -- 135 20 65
  blue = '#7daea3', -- 240 20 65
  magenta = '#d3869b', -- 10 20 65
  brown = '#bd6f3e',
}

function colors:dim(color, level)
  return util.blend(color, self.black, level)
end

function colors:gray(level)
  -- between black and white
  return util.blend(self.white, self.black, level)
end

colors.none = 'NONE'
-- colors.none = colors.black
colors.fg = colors.white
colors.bg = colors.black

colors.bg_popup = colors:gray(0.05)
colors.bg_quote = colors:gray(0.05)
colors.bg_cursor_line = colors:gray(0.1)
colors.bg_fold = colors:gray(0.135)
colors.bg_qf_select = colors:gray(0.135)
colors.bg_visual = colors:gray(0.3)
colors.border = colors:gray(0.2)
colors.non_text = colors:gray(0.5)
colors.status_line = colors:gray(0.75)
colors.search = colors.yellow
colors.title = colors.white

colors.syntax = {
  comment = colors:gray(0.5),
  -- literal = '#a49d92', -- 80 10 65
  -- literal = '#ba904d',
  literal = colors.brown,
  variable = colors.white,
  fn = colors.white,
  type = colors.white,
  keyword = colors.white,

  punctuation = colors:gray(0.5),
  operator = colors.white,
  module = colors.white,
  label = colors.white,
  tag = colors.white,
}

colors.markup = {
  title1 = colors.title,
  title2 = colors.title,
  title3 = colors.title,
  title4 = colors.title,
  title5 = colors.title,
  title6 = colors.title,

  link = colors:gray(0.5),
  url = colors:gray(0.7),
  quote = colors:gray(0.9),
  bullet = colors:gray(0.6),
}

colors.error = colors.red
colors.warning = colors.yellow
colors.info = colors.blue
colors.hint = colors:gray(0.75)
colors.ok = colors.green
colors.guide = colors.green
colors.todo = util.blend(colors.green, colors.black, 0.8)
colors.unused = colors:gray(0.75)

colors.diff = {
  add = colors.green,
  change = colors.blue,
  delete = colors.red,
  text = colors:gray(0.5),

  bg_add = colors:dim(colors.green, 0.3),
  bg_change = colors:dim(colors.blue, 0.3),
  bg_delete = colors:dim(colors.red, 0.3),
  bg_text = colors:dim(colors.blue, 0.5),
}

return colors
