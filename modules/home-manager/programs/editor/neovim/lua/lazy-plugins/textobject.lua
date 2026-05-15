vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
}, { load = true })

vim.opt.runtimepath:prepend(vim.fn.stdpath('data') .. '/nvim-treesitter')

require('nvim-treesitter.configs').setup({
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = 'v',
      node_decremental = 'V',
    },
  },
})

require('nvim-treesitter-textobjects').setup({})

local select_textobject = function(query, group)
  return function()
    require('nvim-treesitter-textobjects.select').select_textobject(query, group)
  end
end
local swap = function(dir, query)
  if dir == 'next' then
    return function()
      require('nvim-treesitter-textobjects.swap').swap_next(query)
    end
  elseif dir == 'prev' then
    return function()
      require('nvim-treesitter-textobjects.swap').swap_previous(query)
    end
  else
    error('')
  end
end

vim.keymap.set({ 'x', 'o' }, 'af', select_textobject('@function.outer', 'textobjects'))
vim.keymap.set({ 'x', 'o' }, 'if', select_textobject('@function.inner', 'textobjects'))
vim.keymap.set({ 'x', 'o' }, 'ac', select_textobject('@class.outer', 'textobjects'))
vim.keymap.set({ 'x', 'o' }, 'ic', select_textobject('@class.inner', 'textobjects'))
vim.keymap.set({ 'x', 'o' }, 'as', select_textobject('@local.scope', 'locals'))

vim.keymap.set('n', '<leader>sp', swap('next', '@parameter.inner'))
vim.keymap.set('n', '<leader>sP', swap('prev', '@parameter.inner'))
