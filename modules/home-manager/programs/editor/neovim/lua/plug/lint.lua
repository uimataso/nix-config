local au = require('utils').au
local ag = require('utils').ag

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

      ag('uima/RunLint', function(g)
        au({ 'BufWritePost' }, {
          group = g,
          callback = function()
            -- require('lint').try_lint('cspell')
          end,
        })
      end)
    end,
  },
}
