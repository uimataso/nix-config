local util = require('uicolors.util')

local M = {}

-- see :h diagnostic-highlights

M.get = function(c)
  return {
    DiagnosticError = { fg = c.diag.error },
    DiagnosticWarn = { fg = c.diag.warn },
    DiagnosticInfo = { fg = c.diag.info },
    DiagnosticHint = { fg = c.diag.hint },
    DiagnosticOk = { fg = c.diag.ok },
    -- DiagnosticVirtualTextError,
    -- DiagnosticVirtualTextWarn,
    -- DiagnosticVirtualTextInfo,
    -- DiagnosticVirtualTextHint,
    -- DiagnosticVirtualTextOk,
    DiagnosticUnderlineError = { bg = c:dim(c.diag.error, 0.3) },
    DiagnosticUnderlineWarn = { bg = c:dim(c.diag.warn, 0.3) },
    DiagnosticUnderlineInfo = {},
    DiagnosticUnderlineHint = {},
    DiagnosticUnderlineOk = {},
    -- DiagnosticUnderlineError = { sp = c:dim(c.error, 0.6), underline = true },
    -- DiagnosticUnderlineWarn = { sp = c:dim(c.warning, 0.6), underline = true },
    -- DiagnosticUnderlineInfo = { sp = c:dim(c.info, 0.6), underline = true },
    -- DiagnosticUnderlineHint = { sp = c:dim(c.hint, 0.6), underline = true },
    -- DiagnosticUnderlineOk = { sp = c:dim(c.ok, 0.6), underline = true },
    -- DiagnosticFloatingError,
    -- DiagnosticFloatingWarn,
    -- DiagnosticFloatingInfo,
    -- DiagnosticFloatingHint,
    -- DiagnosticFloatingOk,
    -- DiagnosticSignError,
    -- DiagnosticSignWarn,
    -- DiagnosticSignInfo,
    -- DiagnosticSignHint,
    -- DiagnosticSignOk,
    DiagnosticDeprecated = { sp = c.diag.unused, strikethrough = true },
    DiagnosticUnnecessary = { fg = c.diag.unused },
  }
end

return M
