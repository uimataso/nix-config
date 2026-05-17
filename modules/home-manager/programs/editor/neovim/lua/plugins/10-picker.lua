vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
}, { load = true })

require('fzf-lua').setup({
  defaults = {
    color_icons = false,
  },
  -- TODO: tweak color
  fzf_colors = {},
})

vim.keymap.set('n', '=', '<leader>ff', { remap = true })

-- completion
vim.keymap.set('i', '<C-x><C-p>', '<cmd>FzfLua complete_path<cr>')
vim.keymap.set('i', '<C-x><C-f>', '<cmd>FzfLua complete_file<cr>')
vim.keymap.set('i', '<C-x><C-l>', '<cmd>FzfLua complete_line<cr>')

-- misc
vim.keymap.set('n', 'z=', '<cmd>FzfLua spell_suggest<cr>')
vim.keymap.set('n', '<leader>he', '<cmd>FzfLua helptags<cr>')
vim.keymap.set('n', '<leader>fr', '<cmd>FzfLua resume<cr>')

-- files
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua vcs_files<cr>')
vim.keymap.set('n', '<leader>fl', '<cmd>FzfLua lines<cr>')

-- search
vim.keymap.set('n', '<Leader>fs', '<cmd>FzfLua live_grep<cr>')
vim.keymap.set({ 'n', 'x' }, '<leader>fw', '<cmd>FzfLua grep_cword<cr>')

vim.keymap.set('n', 'gra', '<cmd>FzfLua lsp_code_actions silent=true<cr>')
vim.keymap.set('n', 'gd', '<cmd>FzfLua lsp_definitions<cr>')
vim.keymap.set('n', 'gD', '<cmd>FzfLua lsp_declarations<cr>')
vim.keymap.set('n', 'grr', '<cmd>FzfLua lsp_references<cr>')
vim.keymap.set('n', 'gri', '<cmd>FzfLua lsp_implementations<cr>')
vim.keymap.set('n', 'grt', '<cmd>FzfLua lsp_typedefs<cr>')
vim.keymap.set('n', 'gro', '<cmd>FzfLua lsp_document_symbols<cr>')
vim.keymap.set('n', 'grO', '<cmd>FzfLua lsp_workspace_symbols<cr>')

vim.keymap.set('n', '<leader>fd', '<cmd>FzfLua diagnostics_workspace<cr>')
vim.keymap.set('n', '<leader>fe', '<cmd>FzfLua diagnostics_workspace severity_limit=2<cr>')
vim.keymap.set('n', '<leader>fD', '<cmd>FzfLua diagnostics_document<cr>')
vim.keymap.set('n', '<leader>fE', '<cmd>FzfLua diagnostics_document severity_limit=2<cr>')
