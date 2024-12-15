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
    DiagnosticUnderlineError = { sp = c.error, underline = true },
    DiagnosticUnderlineWarn = { sp = c.warning, underline = true },
    DiagnosticUnderlineInfo = { sp = c.info, underline = true },
    DiagnosticUnderlineHint = { sp = c.hint, underline = true },
    DiagnosticUnderlineOk = { sp = c.ok, underline = true },
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
    DiagnosticDeprecated = { sp = c.fg, strikethrough = true },
    DiagnosticUnnecessary = { fg = c.unused },
  }
end

return M
