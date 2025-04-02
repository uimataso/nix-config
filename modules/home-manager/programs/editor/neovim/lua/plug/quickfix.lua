return {
  'stevearc/quicker.nvim',
  event = 'FileType qf',

  keys = {
    {
      '<Leader>q',
      mode = { 'n' },
      function()
        require('quicker').toggle()
      end,
      desc = 'Toggle quickfik',
    },
    {
      '<Leader>l',
      mode = { 'n' },
      function()
        require('quicker').toggle({ loclist = true })
      end,
      desc = 'Toggle loclist',
    },
  },

  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {
    keys = {
      {
        '>',
        function()
          require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
    },
    type_icons = {
      E = ' ',
      W = ' ',
      I = ' ',
      N = ' ',
      H = ' ',
    },
  },
}
