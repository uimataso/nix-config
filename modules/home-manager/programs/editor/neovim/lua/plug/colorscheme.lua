return {
  {
    'uimataso/uicolors.nvim',
    -- enabled = false,
    lazy = false,
    dir = '~/.config/nvim/plugins/uicolors.nvim',
    config = function()
      vim.cmd.colorscheme('uicolors')
    end,
  },

  {
    'echasnovski/mini.base16',
    lazy = false,
    enabled = false,
    version = false,
    opts = {
      palette = {
        base00 = '#161616',
        base01 = '#303030',
        base02 = '#454545',
        base03 = '#808080',
        base04 = '#9b9b9b',
        base05 = '#bcbcbc',
        base06 = '#dddddd',
        base07 = '#f5f5f5',
        base08 = '#c68586',
        base09 = '#edb96e',
        base0A = '#d5be95',
        base0B = '#86a586',
        base0C = '#8caeaf',
        base0D = '#83a0af',
        base0E = '#d8afad',
        base0F = '#b08b76',
      },
    },

    config = function(_, opts)
      require('mini.base16').setup(opts)
    end,
  },
}
