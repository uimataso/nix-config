return {
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown',
    ft = { 'markdown', },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      highlights = {
        code = 'CodeBlock',
      },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)
    end,
  }
}
