---@type vim.lsp.Config
return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' },
  root_markers = { '.git' },
  single_file_support = true,

  handlers = {
    -- disable diagnostic on `.env` file
    ['textDocument/publishDiagnostics'] = function(err, res, ...)
      local file_name = vim.fn.fnamemodify(vim.uri_to_fname(res.uri), ':t')
      if string.match(file_name, '^%.env') == nil then
        return vim.lsp.diagnostic.on_publish_diagnostics(err, res, ...)
      end
    end,
  },
}
