return {
  'stevearc/quicker.nvim',
  keys = {
    { '<Leader>q', mode = { 'n' }, function() require("quicker").toggle() end,                   desc = 'Toggle quickfik' },
    { '<Leader>l', mode = { 'n' }, function() require("quicker").toggle({ loclist = true }) end, desc = 'Toggle locfik' },
  },
  opts = {
    keys = {
      {
        ">",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
  },
}
