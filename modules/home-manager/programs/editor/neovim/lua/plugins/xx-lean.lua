vim.pack.add({
  'https://github.com/Julian/lean.nvim',
})

vim.g.lean_config = {
  mappings = true,
  goal_markers = {
    unsolved = ' … ', -- shown inline in incomplete proofs
    accomplished = '∎', -- shown in the sign column for completed proofs
  },
}
