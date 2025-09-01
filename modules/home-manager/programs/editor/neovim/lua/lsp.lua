local get_capabilities = function(override)
  local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  local has_blink, blink = pcall(require, 'blink.cmp')

  local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    has_blink and blink.get_lsp_capabilities() or {},
    override or {}
  )

  return capabilities
end

-- Default lsp config
vim.lsp.config('*', {
  capabilities = get_capabilities({}),
})

-- Auto enable all lsp in lsp directory
local lsp_dir = vim.fn.stdpath('config') .. '/lsp'
local lsp_files = vim.split(vim.fn.glob(lsp_dir .. '/*.lua'), '\n')
for _, file in pairs(lsp_files) do
  local lsp_name = file:gsub(lsp_dir .. '/(.+).lua', '%1')
  vim.lsp.enable(lsp_name)
end

-- https://github.com/neovim/neovim/issues/35401
vim.keymap.set('n', '<C-W>d', function()
  vim.diagnostic.open_float(nil, { close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter' } })
end, { desc = 'Show diagnostics under the cursor' })

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

local au = require('utils').au
local ag = require('utils').ag

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
