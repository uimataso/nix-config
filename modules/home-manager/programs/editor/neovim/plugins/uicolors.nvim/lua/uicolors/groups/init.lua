local M = {}

-- TODO: see also:
-- :h lsp-highlight
-- :h lsp-semantic-highlight

M.plugins = {
  ['blink.cmp'] = 'blink-cmp',
  ['diffview.nvim'] = 'diffview',
  ['eyeliner.nvim'] = 'eyeliner',
  ['fff.nvim'] = 'fff',
  ['flash.nvim'] = 'flash',
  ['fzf-lua'] = 'fzf-lua',
  ['gitsigns.nvim'] = 'gitsigns',
  ['helpview.nvim'] = 'helpview',
  ['indent-blankline.nvim'] = 'indent-blankline',
  ['namu.nvim'] = 'namu',
  ['snacks.nvim'] = 'snacks',
  ['telescope.nvim'] = 'telescope',
  ['vim-illuminate'] = 'vim-illuminate',
  ['visimatch.nvim'] = 'visimatch',
}

M.get = function(name, colors)
  local g = require('uicolors.groups.' .. name)
  return g.get(colors)
end

M.setup = function(colors)
  local groups = {
    default = true,
    custom = true,
    syntax = true,
    treesitter = true,
    diagnostic = true,
  }

  for _, group in pairs(M.plugins) do
    groups['plugins.' .. group] = true
  end

  local ret = {}
  for group_name in pairs(groups) do
    for k, v in pairs(M.get(group_name, colors)) do
      ret[k] = v
    end
  end
  return ret
end

return M
