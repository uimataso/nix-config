vim.pack.add({
  'https://github.com/mfussenegger/nvim-lint',
})

local ag = require('uima').ag

require('uima').overwrite_diagnostic_highlight(
  require('lint').get_namespace('cspell'),
  'uima/CspellLintHighlight',
  'SpellBad'
)

ag('uima/RunLint', function(au)
  au({ 'BufWritePost' }, {
    callback = function()
      -- run cspell on every ft
      require('lint').try_lint('cspell')
    end,
  })
end)
