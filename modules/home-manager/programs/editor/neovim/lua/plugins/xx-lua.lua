vim.pack.add({
  'https://github.com/folke/lazydev.nvim',
})

local ag = require('uima').ag

ag('uima/LuaPlugins', function(au)
  au({ 'FileType' }, {
    pattern = { 'lua' },
    once = true,
    callback = function()
      require('lazydev').setup({
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      })
    end,
  })
end)
