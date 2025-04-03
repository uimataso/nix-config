---@type vim.lsp.Config
return {
  cmd = { 'nixd' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  single_file_support = true,
}
