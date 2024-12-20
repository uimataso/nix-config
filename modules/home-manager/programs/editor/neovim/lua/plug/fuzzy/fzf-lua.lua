return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  command = 'FzfLua',

  keys = {
    { '=', '<cmd>FzfLua files git_icons=false<cr>', desc = 'Find Files' },
    { 'z=', '<cmd>FzfLua spell_suggest<cr>', desc = 'Fzf spell suggest' },

    { '<Leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find Files' },
    { '<Leader>fb', '<cmd>FzfLua buffers<cr>', desc = 'Find Buffer' },
    { '<Leader>fs', '<cmd>FzfLua live_grep<cr>', desc = 'Find by Search' },
    { '<Leader>fs', mode = { 'x' }, '<cmd>FzfLua grep_visual<cr>', desc = 'Find by Search' },
    { '<Leader>fw', '<cmd>FzfLua grep_cword<cr>', desc = 'Find Word' },
    { '<Leader>fW', '<cmd>FzfLua grep_cWORD<cr>', desc = 'Find WORD' },
    { '<Leader>f"', '<cmd>FzfLua registers<cr>', desc = 'Find register' },
    { '<Leader>ft', '<cmd>TodoFzfLua<cr>', desc = 'Find Todo' },
    { '<leader>fj', '<cmd>FzfLua jumps<cr>', desc = 'Find Jumplist' },

    { '<Leader>fd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Find Diagnostic' },
    { '<Leader>fD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Find Diagnostic Wrokspace' },

    { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = 'Git Commits' },
    { '<leader>gs', '<cmd>FzfLua git_status<cr>', desc = 'Git Status' },

    { '<Leader>fh', '<cmd>FzfLua helptags<cr>', desc = 'Find Help' },
    { '<Leader>hl', '<cmd>FzfLua highlights<cr>', desc = 'Find HighLight' },

    { '<C-x><C-p>', mode = { 'i' }, '<cmd>FzfLua complete_path<cr>', desc = 'Fzf Path InsComplete' },
    { '<C-x><C-f>', mode = { 'i' }, '<cmd>FzfLua complete_file<cr>', desc = 'Fzf File InsComplete' },
    { '<C-x><C-l>', mode = { 'i' }, '<cmd>FzfLua complete_line<cr>', desc = 'Fzf Line InsComplete' },
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
        glob_separator = '%s%s', -- query separator pattern (lua): ' '
      },
    })

    require('fzf-lua').register_ui_select()
  end,
}
