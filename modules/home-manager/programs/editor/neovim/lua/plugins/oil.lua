vim.pack.add({
  'https://github.com/barrettruth/canola.nvim',
}, { load = true })

local show_column = false
local toggle_column = function()
  show_column = not show_column
  if show_column then
    require('oil').set_columns({
      'permissions',
      { 'size', align = 'right', highlight = 'Comment' },
      { 'mtime', format = '<%Y-%m-%d %H:%M>', highlight = 'Comment' },
    })
  else
    require('oil').set_columns({})
  end
end

require('oil').setup({
  columns = {},
  win_options = {
    signcolumn = vim.opt.signcolumn:get(),
  },
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['<Esc><Esc>'] = 'actions.close',
    ['q'] = 'actions.close',
    ['-'] = false,
    ['_'] = false,
    ['gd'] = toggle_column,
  },
  float = {
    padding = 3,
    max_width = 100,
    max_height = 0,
  },
})

vim.keymap.set('n', '<leader>o', require('oil').open, { desc = 'Open Oil browser' })

vim.keymap.set('n', '-', function()
  local ft = vim.bo.filetype
  if vim.v.count > 0 or ft == 'oil' then
    vim.api.nvim_feedkeys(vim.v.count .. 'k', 'n', false)
  else
    require('oil').open_float()
  end
end, { desc = 'Open Oil browser' })
