---@type vim.lsp.Config
return {
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown', 'markdown.mdx' },
  root_markers = { '.marksman.toml', '.git' },

  root_dir = function(bufnr, on_dir)
    local notes_root = '/share/notes'
    local buf_path = vim.api.nvim_buf_get_name(bufnr)
    buf_path = vim.fn.fnamemodify(buf_path, ':p')

    vim.print(buf_path)

    if vim.startswith(buf_path, notes_root) then
      on_dir(notes_root)
    end
  end,
}
