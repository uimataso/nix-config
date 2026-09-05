vim.pack.add({ 'https://codeberg.org/andyg/leap.nvim' })

-- See `:h leap-mappings`, `:h leap.visit-mappings` for more.

-- Jump
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

-- Visit (jump - operate - jump back)
vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-visit)')
vim.keymap.set({ 'x', 'o' }, 'ar', '<Plug>(leap-visit-text-object)')
vim.keymap.set({ 'x', 'o' }, 'ir', '<Plug>(leap-visit-inner-text-object)')

vim.keymap.set('o', 'rr', function() -- "visit line" shortcut
  return (vim.v.count == 0 and '1' or '') .. '<Plug>(leap-visit)'
end, { expr = true })

-- Automatic paste on return.
vim.api.nvim_create_autocmd('User', {
  pattern = 'VisitDone',
  group = vim.api.nvim_create_augroup('Visit', {}),
  callback = function(event)
    if
      (event.data.mode:match('^[vV\22]') or (vim.v.operator == 'y'))
      and event.data.register == '"'
    then
      vim.cmd('normal! p')
    end
  end,
})

-- Treeselect
vim.keymap.set({ 'x', 'o' }, 'an', function()
  require('leap.treesitter').select {
    opts = require('leap.user').with_traversal_keys('n', 'N'),
  }
end)

-- Enhanced f/t motions (1-character search)
do
  local function ft(kwargs)
    require('leap').leap(vim.tbl_deep_extend('keep', kwargs, {
      inputlen = 1,
      inclusive = true,
      opts = {
        -- Force autojump.
        labels = '',
        -- Match the modes where you don't need labels (`:h mode()`).
        safe_labels = vim.fn.mode(1):match('no?') and '' or nil,
      },
    }))
  end

  -- A helper function making it easier to set "clever-f" behavior
  -- (using f/F or t/T instead of ;/, - see the plugin clever-f.vim).
  local clever = require('leap.user').with_traversal_keys
  local clever_f, clever_t = clever('f', 'F'), clever('t', 'T')

  vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
    ft { opts = clever_f }
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, 'F', function()
    ft { backward = true, opts = clever_f }
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, 't', function()
    ft { offset = -1, opts = clever_t }
  end)
  vim.keymap.set({ 'n', 'x', 'o' }, 'T', function()
    ft { backward = true, offset = 1, opts = clever_t }
  end)
end
