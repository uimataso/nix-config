local M = {}

M.url = 'https://github.com/nvim-telescope/telescope.nvim'

M.get = function(c)
  return {
    TelescopeNormal = 'NormalFloat',
    TelescopeBorder = 'FloatBorder',

    -- prompt
    TelescopePromptNormal = { bg = c.bg_cursor_line },
    TelescopePromptBorder = { fg = c.bg_cursor_line, bg = c.bg_cursor_line },

    -- title
    TelescopeTitle = {},
    TelescopePreviewTitle = { bg = c.red, bold = true },
    TelescopePromptTitle = { bg = c.green, bold = true },
  }
end

return M
