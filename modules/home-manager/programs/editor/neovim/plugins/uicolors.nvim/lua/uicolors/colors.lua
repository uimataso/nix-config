local util = require('uicolors.util')

local M = {}

function M.setup(base16_palette, opts)
  local c = base16_palette

  function c:dim(color, level)
    return util.blend(color, self.base00, level)
  end

  -- Color name for human :)
  c.black = c.base00
  c.white = c.base05
  c.red = c.base08
  c.orange = c.base09
  c.yellow = c.base0A
  c.green = c.base0B
  c.cyan = c.base0C
  c.blue = c.base0D
  c.magenta = c.base0E
  c.brown = c.base0F

  c.none = opts.trans_bg and 'NONE' or c.black
  c.fg = c.white
  c.bg = c.black

  c.bg_popup = c.base01
  c.bg_quote = c.base01
  c.bg_cursor_line = util.blend(c.base02, c.base01, 0.5)
  c.bg_selection = c.base02
  c.bg_fold = c.base03
  c.bg_visual = c.base02
  c.border = c.base02
  c.non_text = c.base04
  c.status_line = util.blend(c.base05, c.base04, 0.5)
  c.selection = c.white

  c.syntax = {
    comment = c.base04,
    literal = c.orange,
    variable = c.white,
    fn = c.white,
    type = c.white,
    keyword = c.white,

    punctuation = c.base04,
    operator = c.white,
    module = c.white,
    label = c.white,
    tag = util.blend(c.base05, c.base04, 0.5),
  }

  c.markup = {
    title1 = c.title,
    title2 = c.title,
    title3 = c.title,
    title4 = c.title,
    title5 = c.title,
    title6 = c.title,

    link = c.base04,
    link_sp = c.base02,
    quote = c.white,
    bullet = c.base04,
  }

  c.footer = c.base04
  c.title = c.magenta
  c.search = c.yellow
  c.error = c.red
  c.warning = c.yellow
  c.info = c.blue
  c.hint = c.base04
  c.ok = c.green
  c.guide = c.green
  c.todo = c:dim(c.green, 0.8)
  c.unused = util.blend(c.base05, c.base04, 0.5)

  c.diff = {
    add = c.green,
    change = c.blue,
    delete = c.red,
    text = c.base04,
  }

  return c
end

return M
