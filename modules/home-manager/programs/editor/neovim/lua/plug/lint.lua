return {
  {
    'mfussenegger/nvim-lint',
    lazy = false,
    config = function()
      require('utils').overwrite_diagnostic_highlight(
        require('lint').get_namespace('cspell'),
        'uima/CspellLintHighlight',
        'SpellBad'
      )

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint('cspell')
        end,
      })
    end,
  },
}
