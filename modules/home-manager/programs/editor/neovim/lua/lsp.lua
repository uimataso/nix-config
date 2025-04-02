local au = require('utils').au
local ag = require('utils').ag
ag('uima/LspKeymap', function(g)
  au({ 'LspAttach' }, {
    group = g,
    callback = function()
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition()' })
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'vim.lsp.buf.declaration()' })
    end,
  })
end)

ag('uima/LspFold', function(g)
  au({ 'LspAttach' }, {
    group = g,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client:supports_method('textDocument/foldingRange') then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end
    end,
  })
end)

vim.diagnostic.config({
  virtual_text = false,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    source = true,
    header = '',
    prefix = '',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
})
