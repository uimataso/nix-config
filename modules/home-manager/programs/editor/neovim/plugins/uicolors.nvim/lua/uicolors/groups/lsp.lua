local M = {}

-- see :h lsp-highlight

M.get = function(c)
  return {
    -- TODO: wtf is these
    -- LspReferenceText,
    -- LspReferenceRead,
    -- LspReferenceWrite,
    -- LspInlayHint,
    -- LspCodeLens,
    -- LspCodeLensSeparator,
    -- LspSignatureActiveParameter,
  }
end

return M
