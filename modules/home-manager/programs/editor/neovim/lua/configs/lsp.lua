vim.api.nvim_create_user_command('LspInfo', 'checkhealth vim.lsp', {})

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

local sev = vim.diagnostic.severity

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
      [sev.ERROR] = '',
      [sev.WARN] = '',
      [sev.INFO] = '',
      [sev.HINT] = '',
    },
    numhl = {
      [sev.ERROR] = 'DiagnosticError',
      [sev.WARN] = 'DiagnosticWarn',
      [sev.INFO] = 'DiagnosticInfo',
      [sev.HINT] = 'DiagnosticHint',
    },
  },
})

vim.keymap.set('n', '<Leader>a', 'gra', { remap = true })
vim.keymap.set('n', '<M-a>', 'gra', { remap = true })

local diagnostic_virtual_lines = false
local toggle_diagnostic_virtual_lines = function()
  diagnostic_virtual_lines = not diagnostic_virtual_lines
  vim.diagnostic.config({ virtual_lines = diagnostic_virtual_lines })
end
vim.keymap.set(
  'n',
  '<leader>df',
  toggle_diagnostic_virtual_lines,
  { desc = 'vim.diagnostic.config({ virtual_lines = .. })' }
)

local set_di2qf = function(buf, get_opts)
  return function()
    local diagnostics = vim.diagnostic.get(buf, get_opts)
    local qf_list = vim.diagnostic.toqflist(diagnostics)
    vim.fn.setqflist(qf_list, 'r')

    if #diagnostics > 0 then
      vim.cmd.copen()
    else
      vim.notify('no diagnostics')
    end
  end
end

vim.keymap.set('n', '<Leader>dd', set_di2qf(nil, {}))
vim.keymap.set('n', '<Leader>de', set_di2qf(nil, { severity = { min = sev.WARN } }))
vim.keymap.set('n', '<Leader>DD', set_di2qf(0, {}))
vim.keymap.set('n', '<Leader>DE', set_di2qf(0, { severity = { min = sev.WARN } }))

local show_documentation = function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand('%:t')

  local has_ufo, ufo = pcall(require, 'ufo')
  if has_ufo and ufo.peekFoldedLinesUnderCursor() then
    return
  end

  if file == 'Cargo.toml' then
    local has_crates, crates = pcall(require, 'crates')
    if has_crates and crates.popup_available() then
      return crates.show_popup()
    end
  end

  if ft == 'rust' then
    return vim.cmd.RustLsp { 'hover', 'actions' }
  end

  return vim.lsp.buf.hover()
end
vim.keymap.set(
  'n',
  'K',
  show_documentation,
  { silent = true, desc = 'vim.lsp.buf.hover() but more' }
)
