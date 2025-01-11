local M = {}

M.plugins = {
  ['blink.cmp'] = 'blink-cmp',
  ['diffview.nvim'] = 'diffview',
  ['fzf-lua'] = 'fzf-lua',
  ['gitsigns.nvim'] = 'gitsigns',
  ['helpview.nvim'] = 'helpview',
  ['indent-blankline.nvim'] = 'indent-blankline',
  ['telescope.nvim'] = 'telescope',
}

M.get = function(name, colors)
  local g = require('uicolors.groups.' .. name)
  return g.get(colors)
end

M.setup = function(colors)
  local groups = {
    base = true,
    treesitter = true,
    syntax = true,
    lsp = true,
    diagnostic = true,
    custom = true,
  }

  for _, group in pairs(M.plugins) do
    groups[group] = true
  end

  -- local plugins = require('lazy.core.config').plugins
  -- for plugin, group in pairs(M.plugins) do
  --   if plugins[plugin] then
  --     groups[group] = true
  --   end
  -- end

  local ret = {}
  for group in pairs(groups) do
    for k, v in pairs(M.get(group, colors)) do
      ret[k] = v
    end
  end
  return ret
end

return M
