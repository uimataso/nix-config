vim.pack.add({
  'https://github.com/folke/which-key.nvim',
}, { load = true })

require('which-key').setup({
  preset = 'modern', -- "classic" | "modern" | "helix"
  triggers = {
    { '<leader>c', mode = { 'n', 'x' } },
    { '<leader>a', mode = 'x' },
    { '<C-d>', mode = 'i' },
    { '<C-g>', mode = 'i' },
  },
  spec = {
    { '<C-d>', mode = 'i', group = 'insert date/time' },
    { '<C-g>', mode = 'i', group = 'insert misc' },
    { '<leader>a', mode = 'x', group = 'align' },
    { '<leader>c', mode = { 'n', 'x' }, group = 'text-case' },
    { '<leader>co', mode = 'n', group = 'operator' },
    { '<leader>f', mode = 'n', group = 'find' }, -- fzf-lua + todo-comments
    { '<leader>t', mode = 'n', group = 'toggle' }, -- gitsigns/spell/conceal toggles + run tests
    { '<leader>/', mode = 'n', group = 'multicursor search' },
    { '<leader>g', mode = { 'n', 'x' }, group = 'git' }, -- also has multicursor's ga/gv
    { '<leader>d', mode = 'n', group = 'diagnostics/diff' },
    { '<leader>D', mode = 'n', group = 'diagnostics (workspace)' },
    { '<leader>y', mode = { 'n', 'x' }, group = 'yank' },
    { '<leader>r', mode = 'n', group = 'run' }, -- RunCmd + rust-analyzer actions
    { '<leader>h', mode = 'n', group = 'help' },
    { '<leader>s', mode = { 'n', 'x' }, group = 'swap/substitute' }, -- also multicursor skip-cursor leaf
    { '<leader>w', mode = 'n', group = 'wayfinder' },
    { '<leader><leader>', mode = 'n', group = 'buffer-wide' }, -- whole-buffer yank/run
  },
})

vim.keymap.set('n', '<leader>?', function()
  require('which-key').show({ global = false })
end, { desc = 'which key' })
