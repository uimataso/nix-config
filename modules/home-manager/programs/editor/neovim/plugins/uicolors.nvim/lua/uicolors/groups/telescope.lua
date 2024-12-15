local M = {}

M.url = 'https://github.com/nvim-telescope/telescope.nvim'

M.get = function(c)
  return {
    TelescopeNormal = 'NormalFloat',
    TelescopeBorder = 'FloatBorder',
    TelescopePromptNormal = { bg = c.bg_prompt },
    TelescopePromptBorder = { fg = c.bg_prompt, bg = c.bg_prompt },

    TelescopeTitle = {},
    TelescopePreviewTitle = { bg = c.red, bold = true },
    TelescopePromptTitle = { bg = c.green, bold = true },
  }
end

return M
