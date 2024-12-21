local M = {}

M.border = 'rounded'

M.signs = {
  diagnostic = {
    [vim.diagnostic.severity.ERROR] = '',
    [vim.diagnostic.severity.WARN] = '',
    [vim.diagnostic.severity.HINT] = '',
    [vim.diagnostic.severity.INFO] = '',
  },
}

-- TODO:
-- local function set_sign(level, sign)
--   local name = 'DiagnosticSign' .. level
--   vim.fn.sign_define(name, { texthl = name, text = sign, numhl = '' })
-- end
-- set_sign('Error', '')
-- set_sign('Warn', '')
-- set_sign('Hint', '')
-- set_sign('Info', '')

return M
