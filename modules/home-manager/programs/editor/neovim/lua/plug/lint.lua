return {
  {
    'mfussenegger/nvim-lint',
    -- lazy = false,
    config = function()
      -- vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      --   callback = function()
      --     -- run typos on all filetype
      --     require('lint').try_lint('typos')
      --   end,
      -- })
    end,
  },
}
