return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<C-x><C-p>', mode = { 'i' }, function() require('fzf-lua').complete_path() end },
    { '<C-x><C-f>', mode = { 'i' }, function() require('fzf-lua').complete_file() end },
    { '<C-x><C-l>', mode = { 'i' }, function() require('fzf-lua').complete_line() end },
  },
  config = function()
    require('fzf-lua').setup({
      -- https://www.reddit.com/r/neovim/comments/1hhiidm/a_few_nice_fzflua_configurations_now_that_lazyvim/
      oldfiles = {
        include_current_session = true,
      },
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100, -- 100KB
        },
      },
      grep = {
        rg_glob = true, -- enable glob parsing
        glob_flag = '--iglob', -- case insensitive globs
        glob_separator = '%s%-%-', -- query separator pattern (lua): ' --'
      },
    })
  end,
}
