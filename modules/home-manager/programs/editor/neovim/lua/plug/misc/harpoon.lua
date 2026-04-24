return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },

  keys = {
    {
      '<leader>m',
      mode = { 'n' },
      function()
        require('harpoon'):list():add()
      end,
      desc = 'harpoon add list',
    },
    {
      '<leader>l',
      mode = { 'n' },
      function()
        require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
      end,
      desc = 'harpoon toggle menu',
    },

    -- stylua: ignore start
    { '<C-n>', mode = { 'n' }, function() require('harpoon'):list():next() end, desc = 'harpoon next' },
    { '<C-p>', mode = { 'n' }, function() require('harpoon'):list():prev() end, desc = 'harpoon prev' },
    -- stylua: ignore end
  },

  opts = {},
}
