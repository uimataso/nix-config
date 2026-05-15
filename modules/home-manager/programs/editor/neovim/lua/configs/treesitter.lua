local ag = require('uima').ag

vim.opt.runtimepath:prepend(vim.fn.stdpath('data') .. '/nvim-treesitter')

ag('uima/Treesitter', function(au)
  au('FileType', {
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
