return {
  'kevinhwang91/nvim-ufo',
  event = 'VeryLazy',
  dependencies = {
    'kevinhwang91/promise-async',
  },

  keys = {
    { 'zR', function() require('ufo').openAllFolds() end,         desc = 'ufo open all folds' },
    { 'zM', function() require('ufo').closeAllFolds() end,        desc = 'ufo close all flods' },
    { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = '' },
    { 'zm', function() require('ufo').closeFoldsWith() end },

    { '<enter>', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then vim.lsp.buf.hover() end
    end
    },
  },

  init = function()
    vim.opt.foldlevel = 9999
  end,

  opts = {
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end,

    preview = {
      win_config = {
        border = 'none',
        winhighlight = 'Normal:Folded',
      },
    },

    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = ('    [ %d ] '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end
  },
}
