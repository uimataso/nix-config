local util = require('uicolors.util')

local M = {}

-- see :h diagnostic-highlights

M.get = function(c)
  return {
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.warning },
    DiagnosticInfo = { fg = c.info },
    DiagnosticHint = { fg = c.hint },
    DiagnosticOk = { fg = c.ok },
    -- DiagnosticVirtualTextError,
    -- DiagnosticVirtualTextWarn,
    -- DiagnosticVirtualTextInfo,
    -- DiagnosticVirtualTextHint,
    -- DiagnosticVirtualTextOk,
    DiagnosticUnderlineError = { sp = c:dim(c.error, 0.6), underline = true },
    DiagnosticUnderlineWarn = { sp = c:dim(c.warning, 0.6), underline = true },
    DiagnosticUnderlineInfo = { sp = c:dim(c.info, 0.6), underline = true },
    DiagnosticUnderlineHint = { sp = c:dim(c.hint, 0.6), underline = true },
    DiagnosticUnderlineOk = { sp = c:dim(c.ok, 0.6), underline = true },
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
    DiagnosticDeprecated = { sp = c.unused, strikethrough = true },
    DiagnosticUnnecessary = { fg = c.unused },
  }
end

return M
