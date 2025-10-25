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

-- Disable default markdown conceal for code block
-- from: https://github.com/nvim-treesitter/nvim-treesitter/issues/5751
require('vim.treesitter.query').set(
  'markdown',
  'highlights',
  [[
;From MDeiml/tree-sitter-markdown
[
  (fenced_code_block_delimiter)
] @punctuation.delimiter
]]
)
