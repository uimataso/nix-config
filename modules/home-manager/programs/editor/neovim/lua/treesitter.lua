vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/nvim-treesitter')

local au = require('utils').au
local ag = require('utils').ag
ag('uima/Treesitter', function(g)
  au('FileType', {
    group = g,
    callback = function()
      local res, _ = pcall(vim.treesitter.start)
      if res then
        vim.bo.syntax = 'ON'
      end
    end,
  })
end)
