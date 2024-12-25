return {
  'aaronik/treewalker.nvim',
  version = false,
  keys = {
    { '<C-h>', mode = { 'n', 'v' }, '<cmd>Treewalker Left<cr>', desc = 'Move visual block left' },
    { '<C-l>', mode = { 'n', 'v' }, '<cmd>Treewalker Right<cr>', desc = 'Move visual block right' },
    { '<C-j>', mode = { 'n', 'v' }, '<cmd>Treewalker Down<cr>', desc = 'Move visual block down' },
    { '<C-k>', mode = { 'n', 'v' }, '<cmd>Treewalker Up<cr>', desc = 'Move visual block up' },
    { '<C-S-j>', mode = 'n', '<cmd>Treewalker SwapDown<cr>', desc = 'Swap block down' },
    { '<C-S-k>', mode = 'n', '<cmd>Treewalker SwapUp<cr>', desc = 'Swap block up' },
  },
  opts = {
    highlight = true, -- Whether to briefly highlight the node after jumping to it
    highlight_duration = 250, -- How long should above highlight last (in ms)
  },
}
