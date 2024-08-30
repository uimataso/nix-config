return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',

    'nvim-telescope/telescope.nvim',
  },

  command = 'Neogit',

  keys = {
    {
      '<Leader>git',
      mode = { 'n' },
      function()
        require('neogit').open()
      end,
      desc = 'Open neogit',
    },
  },

  opts = {
    integrations = {
      telescope = true,
      diffview = true,
    },
  },
}
