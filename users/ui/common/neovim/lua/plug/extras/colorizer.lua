return {
  'norcalli/nvim-colorizer.lua',
  event = 'VeryLazy',
  config = function()
    require('colorizer').setup(
      {
        '*',
        css = {
          css = true,
          css_fn = true,
        },
      },
      {
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
      }
    )
  end
}
