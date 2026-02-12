return {
  'Vonr/align.nvim',

  keys = {
    {
      '<Leader>aa',
      mode = { 'x' },
      function()
        require 'align'.align_to_char({
          length = 1,
        })
      end,
    },
    {
      '<Leader>ag',
      mode = { 'x' },
      function()
        require 'align'.align_to_string({
          preview = true,
          regex = true,
        })
      end,
    },
  },

  init = function() end,
}
