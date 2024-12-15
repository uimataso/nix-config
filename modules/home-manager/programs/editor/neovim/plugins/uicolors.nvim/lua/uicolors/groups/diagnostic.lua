local M = {}

-- see :h diagnostic-highlights

M.get = function(c)
  return {
    DiagnosticError,
    DiagnosticWarn,
    DiagnosticInfo,
    DiagnosticHint,
    DiagnosticOk,
    DiagnosticVirtualTextError,
    DiagnosticVirtualTextWarn,
    DiagnosticVirtualTextInfo,
    DiagnosticVirtualTextHint,
    DiagnosticVirtualTextOk,
    DiagnosticUnderlineError,
    DiagnosticUnderlineWarn,
    DiagnosticUnderlineInfo,
    DiagnosticUnderlineHint,
    DiagnosticUnderlineOk,
    DiagnosticFloatingError,
    DiagnosticFloatingWarn,
    DiagnosticFloatingInfo,
    DiagnosticFloatingHint,
    DiagnosticFloatingOk,
    DiagnosticSignError,
    DiagnosticSignWarn,
    DiagnosticSignInfo,
    DiagnosticSignHint,
    DiagnosticSignOk,
    DiagnosticDeprecated,
    DiagnosticUnnecessary,
  }
end

return M
