local util = require('uicolors.util')

local M = {}

function M.setup(base16_palette, opts)
  local c = base16_palette

  function c:dim(color, level)
    return util.blend(color, self.base00, level)
  end

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

  c.ui = {
    cursor_line = util.blend(c.base02, c.base01, 0.5),
    border = c.base02,
    fold_line = c.base03,
    popup = c.base01,
    selection = c.base02,
    search = c.yellow,
  }

  c.ui_text = {
    line_number = c.base04,
    status_line = util.blend(c.base05, c.base04, 0.5),
    non_text = c.base04,
    guide = c.green,
  }

  c.diag = {
    error = c.red,
    warn = c.yellow,
    info = c.blue,
    hint = c.cyan,
    ok = c.green,

    todo = c:dim(c.green, 0.8),
    note = c:dim(c.white, 0.8),
    unused = util.blend(c.base05, c.base04, 0.5),
  }

  c.diff = {
    add = c.green,
    change = c.blue,
    delete = c.red,
    text = c.base04,
  }

  c.markup = {
    title = c.base06,
    footer = c.base04,
    link = c.base04,
    link_sp = c.base02,
    quote = c.white,
    raw = c.white,
    raw_bg = c.base01,
    bullet = c.base04,
  }

  c.syntax = {
    variable = c.white,
    constant = c.white,
    literal = c.orange,
    fn = c.white,
    type = c.white,

    keyword = c.white,
    module = c.white,
    label = c.white,
    punctuation = c.base04,
    operator = c.white,
    comment = c.base04,
    tag = util.blend(c.base05, c.base04, 0.5),
  }

  c.misc = {
    directory = c.blue,
  }

  return c
end

return M
