return {
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  opts = {
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
    highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
  },
}
