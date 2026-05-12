return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 500,
        use_focus = true,
      },
      current_line_blame_formatter = '     <author>, <author_time:%R> - <summary>',
    },
  },

  {
    'NeogitOrg/neogit',
    dependencies = {
      'sindrets/diffview.nvim',
      'm00qek/baleia.nvim',
      'folke/snacks.nvim',
    },
    cmd = 'Neogit',

    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
    },

    opts = {
      commit_editor = {
        staged_diff_split_kind = 'auto',
      },
      integrations = {
        fzf_lua = false, -- use snacks.picker
      },
    },
  },
}
