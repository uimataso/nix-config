vim.pack.add({
  'https://github.com/folke/todo-comments.nvim',
}, { load = true })

require('todo-comments').setup({
  signs = false,
  keywords = {
    FIX = {
      icon = ' ',
      color = 'error',
      alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
    },
    HACK = { icon = ' ', color = 'warning' },
    WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
    TODO = { icon = ' ', color = 'todo' },
    PERF = { icon = '󰔛 ', color = 'todo', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
    NOTE = { icon = '󰍨 ', color = 'note', alt = { 'INFO' } },
    TEST = { icon = ' ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
  },
  colors = {
    error = { '@comment.error', 'DiagnosticError', 'ErrorMsg' },
    warning = { '@comment.warning', 'DiagnosticWarn', 'WarningMsg' },
    todo = { '@comment.todo', 'DiagnosticInfo' },
    note = { '@comment.note', 'DiagnosticHint' },
    test = { '@comment.warning', 'Identifier' },
    default = { '@comment', 'Comment' },
  },

  -- match author also: KEYWORD(author):
  -- https://github.com/folke/todo-comments.nvim/issues/10#issuecomment-2446101986
  search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
  highlight = {
    multiline = false,
    pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
  },
})

vim.keymap.set('n', '<leader>ft', '<cmd>TodoFzfLua<cr>', { desc = 'Todo' })
