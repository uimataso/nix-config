local M = {}

-- see :h lsp-highlight

M.get = function(c)
  return {
    LspReferenceText,
    LspReferenceRead,
    LspReferenceWrite,
    LspInlayHint,
    LspCodeLens,
    LspCodeLensSeparator,
    LspSignatureActiveParameter,
  }
end

return M
