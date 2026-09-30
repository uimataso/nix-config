-- Eight-color scheme
local lexers = vis.lexers

local c = {
  ['base00'] = '#161616',
  ['base01'] = '#201f1d',
  ['base02'] = '#34302b',
  ['base03'] = '#524b40',
  ['base04'] = '#7a6f5c',
  ['base05'] = '#ddc7a1',
  ['base06'] = '#ebdbb2',
  ['base07'] = '#fbf1c7',
  ['base08'] = '#ea6962',
  ['base09'] = '#e78a4e',
  ['base0A'] = '#d8a657',
  ['base0B'] = '#a9b665',
  ['base0C'] = '#89b482',
  ['base0D'] = '#7daea3',
  ['base0E'] = '#d3869b',
  ['base0F'] = '#bd6f3e',
}

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
function blend(foreground, background, alpha)
  local function hexToRgb(c)
    c = string.lower(c)
    return {
      tonumber(c:sub(2, 3), 16),
      tonumber(c:sub(4, 5), 16),
      tonumber(c:sub(6, 7), 16),
    }
  end

  alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha
  local bg = hexToRgb(background)
  local fg = hexToRgb(foreground)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format('#%02x%02x%02x', blendChannel(1), blendChannel(2), blendChannel(3))
end

local cursor_line_bg = blend(c.base01, c.base02, 0.5)

lexers.STYLE_DEFAULT = ''
lexers.STYLE_NOTHING = ''
lexers.STYLE_CLASS = 'bold'
lexers.STYLE_COMMENT = 'fore:' .. c.base04
lexers.STYLE_CONSTANT = ''
lexers.STYLE_DEFINITION = ''
lexers.STYLE_ERROR = 'fore:' .. c.base08
lexers.STYLE_FUNCTION = ''
lexers.STYLE_KEYWORD = 'bold'
lexers.STYLE_LABEL = 'bold'
lexers.STYLE_NUMBER = 'fore:' .. c.base09
lexers.STYLE_OPERATOR = ''
lexers.STYLE_REGEX = 'fore:' .. c.base0B
lexers.STYLE_STRING = 'fore:' .. c.base09
lexers.STYLE_PREPROCESSOR = 'bold'
lexers.STYLE_TAG = ''
lexers.STYLE_TYPE = ''
lexers.STYLE_VARIABLE = ''
lexers.STYLE_WHITESPACE = ''
lexers.STYLE_EMBEDDED = ''
lexers.STYLE_IDENTIFIER = ''

lexers.STYLE_LINENUMBER = 'fore:' .. c.base04
lexers.STYLE_LINENUMBER_CURSOR = 'fore:' .. c.base05 .. ',back:' .. cursor_line_bg .. ',bold'
lexers.STYLE_CURSOR = 'back:' .. c.base05 .. ',keep_attribute'
lexers.STYLE_CURSOR_PRIMARY = lexers.STYLE_CURSOR_PRIMARY
lexers.STYLE_CURSOR_LINE = 'back:' .. cursor_line_bg .. ',keep_attribute'
lexers.STYLE_COLOR_COLUMN = 'back:' .. c.base03
lexers.STYLE_SELECTION = 'back:' .. c.base02
lexers.STYLE_STATUS = 'fore:' .. blend(c.base05, c.base04, 0.5) .. ',back:' .. c.base01
lexers.STYLE_STATUS_FOCUSED = lexers.STYLE_STATUS .. ',bold'
lexers.STYLE_SEPARATOR = 'fore:' .. c.base03
lexers.STYLE_INFO = 'bold'
lexers.STYLE_EOF = ''
