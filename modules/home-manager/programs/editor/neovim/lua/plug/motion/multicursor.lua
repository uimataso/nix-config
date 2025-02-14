local mc = function()
  return require('multicursor-nvim')
end

return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  enabled = false,

  -- stylua: ignore start
  keys = {
    {
      '<esc>', mode = 'n',
      function()
        local mc = mc()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end,
      desc = 'clear cursors'
    },

    { '<up>',   mode = { 'n', 'x' }, function() mc().lineAddCursor(-1) end, desc = 'add cursor above the main cursor' },
    { '<down>', mode = { 'n', 'x' }, function() mc().lineAddCursor(1) end, desc = 'add cursor below the main cursor' },
    { '<leader><up>',   mode = { 'n', 'x' }, function() mc().lineSkipCursor(-1) end, desc = 'skip cursor above the main cursor' },
    { '<leader><down>', mode = { 'n', 'x' }, function() mc().lineSkipCursor(1) end, desc = 'skip cursor below the main cursor' },

    { '<leader>n', mode = { 'n', 'x' }, function() mc().matchAddCursor(1) end, desc = 'add cursor by matching word/selection forward' },
    { '<leader>N', mode = { 'n', 'x' }, function() mc().matchAddCursor(-1) end, desc = 'add cursor by matching word/selection forward' },
    { '<leader>s', mode = { 'n', 'x' }, function() mc().matchSkipCursor(1) end, desc = 'skip adding cursor by matching word/selection backward' },
    { '<leader>S', mode = { 'n', 'x' }, function() mc().matchSkipCursor(-1) end, desc = 'skip adding cursor by matching word/selection backward' },

    { '<left>',  mode = { 'n', 'x' }, function() mc().nextCursor() end, desc = 'rotate the main cursor' },
    { '<right>', mode = { 'n', 'x' }, function() mc().prevCursor() end, desc = 'rotate the main cursor' },

    { '<leader>x', mode = { 'n', 'x' }, function() mc().deleteCursor() end, desc = 'delete the main cursor' },

    { 'mw', mode = { 'n', 'x' }, function() mc().operator({ motion = 'iw', visual = true }) end, desc = '' },
    { 'mW', mode = 'n', function() mc().operator() end, desc = '' },

    { '<leader>A', mode = { 'n', 'x' }, function() mc().matchAllAddCursors() end, desc = 'add cursors for all matches in the document' },

    -- You can also add cursors with any motion you prefer:
    -- set("n", "<right>", function() mc.addCursor("w") end)
    -- set("n", "<leader><right>", function() mc.skipCursor("w") end)

    { '<c-q>', mode = { 'n', 'x' }, function() mc().toggleCursor() end, desc = 'manually add and remove cursor' },
    { '<leader><c-q>', mode = { 'n', 'x' }, function() mc().toggleCursor() end, desc = 'clone every cursor and disable the originals' },

    { '<c-leftmouse>', mode = 'n', function() mc().handleMouse() end, desc = 'add cursor by mouse' },
    { '<c-leftdrag>', mode = 'n', function() mc().handleMouseDrag() end, desc = 'add cursor by mouse' },

    { '<leader>gv', mode = 'n', function() mc().restoreCursors() end, desc = 'restore cursor' },
    { '<leader>a', mode = 'n', function() mc().alignCursors() end, desc = 'align cursor columns' },

    { 'S', mode = 'x', function() mc().splitCursors() end, desc = 'split visual selections by regex' },
    { 'I', mode = 'x', function() mc().insertVisual() end, desc = 'insert for each line of visual selections' },
    { 'A', mode = 'x', function() mc().appendVisual() end, desc = 'append for each line of visual selections' },
    { 'M', mode = 'x', function() mc().matchCursors() end, desc = 'match new cursors within visual selections by regex' },

    { '<leader>t', mode = 'x', function() mc().transposeCursors(1) end, desc = 'rotate visual selection contents' },
    { '<leader>T', mode = 'x', function() mc().transposeCursors(-1) end, desc = 'rotate visual selection contents' },

    { '<c-i>', mode = { 'n', 'x' }, function() mc().jumpForward() end, desc = 'jumplist forward' },
    { '<c-o>', mode = { 'n', 'x' }, function() mc().jumpBackward() end, desc = 'jumplist backward' },

  },
  -- stylua: ignore end

  config = function()
    local mc = require('multicursor-nvim')
    mc.setup()

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, 'MultiCursorCursor', { link = 'Cursor' })
    hl(0, 'MultiCursorVisual', { link = 'Visual' })
    hl(0, 'MultiCursorSign', { link = 'SignColumn' })
    hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
    hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
    hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
    hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
  end,
}
