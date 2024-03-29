local util = require 'uicolors.util'
local color = require 'uicolors.color'

color['bg'] = color.black
color['fg'] = color.white

color['gray0'] = util.blend(color.fg, color.bg, 0.05)
color['gray1'] = util.blend(color.fg, color.bg, 0.1)
color['gray2'] = util.blend(color.fg, color.bg, 0.2)
color['gray3'] = util.blend(color.fg, color.bg, 0.3)
color['gray4'] = util.blend(color.fg, color.bg, 0.4)
color['gray5'] = util.blend(color.fg, color.bg, 0.5)
color['gray6'] = util.blend(color.fg, color.bg, 0.6)
color['gray7'] = util.blend(color.fg, color.bg, 0.7)
color['gray8'] = util.blend(color.fg, color.bg, 0.8)
color['gray9'] = util.blend(color.fg, color.bg, 0.9)


-- UI --
color['cursor_line'] = color.gray1
color['nontext'] = color.gray4
color['float_bg'] = color.gray0


-- Syntax --
color['comment'] = color.gray5

color['preproc'] = color.red
color['keyword'] = color.magenta
color['func'] = color.blue
color['type'] = color.cyan
color['field'] = color.white
color['namespace'] = color.gray8
color['punctuation'] = color.gray6

color['variable'] = color.white
color['constant'] = color.white
color['string'] = color.yellow
color['value'] = color.yellow

color['uri'] = color.cyan

color['diff_add'] = util.blend('#00ff00',  color.bg, 0.15)
color['diff_delete'] = util.blend('#ff0000',  color.bg, 0.15)


-- Plugin --
color['prompt'] = color.gray1

color['neorg_tags_ranver_name'] = util.blend(color.magenta,     color.bg, 0.4)
color['neorg_tags_ranver_deli'] = util.blend(color.punctuation, color.bg, 0.4)
color['neorg_tags_ranver_para'] = util.blend(color.blue,        color.bg, 0.4)


return color
