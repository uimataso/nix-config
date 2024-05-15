return {
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown',
    ft = { 'markdown', },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup()
    end,
  }
}
