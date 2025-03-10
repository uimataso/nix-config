return {
  'zbirenbaum/neodim',
  event = 'LspAttach',
  opts = {
    blend_color = '#000000',
    regex = {
      '[uU]nused',
      '[nN]ever [rR]ead',
      '[nN]ot [rR]ead',
      cs = {
        'CS8019',
      },
      rust = {},
    },
    disable = {},
  },
}
