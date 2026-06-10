vim.pack.add({
  'https://github.com/jake-stewart/multicursor.nvim',
})

local mc = require('multicursor-nvim')

mc.setup()

-- Add or skip cursor above/below the main cursor.
-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, '<c-.>', function() mc.lineAddCursor(1) end)
vim.keymap.set({ 'n', 'x' }, '<c-,>', function() mc.lineAddCursor(-1) end)
vim.keymap.set({ 'n', 'x' }, '<c-s->>', function() mc.lineSkipCursor(1) end)
vim.keymap.set({ 'n', 'x' }, '<c-s-lt>', function() mc.lineSkipCursor(-1) end)
-- stylua: ignore end

-- Add or skip adding a new cursor by matching word/selection
-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, '<leader>n', function() mc.matchAddCursor(1) end)
vim.keymap.set({ 'n', 'x' }, '<leader>s', function() mc.matchSkipCursor(1) end)
vim.keymap.set({ 'n', 'x' }, '<leader>N', function() mc.matchAddCursor(-1) end)
vim.keymap.set({ 'n', 'x' }, '<leader>S', function() mc.matchSkipCursor(-1) end)
-- stylua: ignore end

-- Disable and enable cursors.
vim.keymap.set({ 'n', 'x' }, '<c-q>', mc.toggleCursor)
-- bring back cursors if you accidentally clear them
vim.keymap.set('n', '<leader>gv', mc.restoreCursors)

-- Pressing `gaip` will add a cursor on each line of a paragraph.
vim.keymap.set({ 'n', 'x' }, 'ga', mc.addCursorOperator)
-- Pressing `<leader>gaiwap` will create a cursor in every match of the
-- string captured by `iw` inside range `ap`.
-- This action is highly customizable, see `:h multicursor-operator`.
vim.keymap.set({ 'n', 'x' }, '<leader>ga', mc.operator)

-- match new cursors within visual selections by regex.
vim.keymap.set('x', 'M', mc.matchCursors)

-- Append/insert for each line of visual selections.
-- Similar to block selection insertion.
vim.keymap.set('v', 'I', function()
  -- ref: https://github.com/jake-stewart/multicursor.nvim/blob/704b99f10a72cc05d370cfeb294ff83412a8ab55/lua/multicursor-nvim/examples.lua#L472
  local TERM_CODES = require('multicursor-nvim.term-codes')
  local mode = vim.fn.mode()
  mc.action(function(ctx)
    ctx:forEachCursor(function(cursor)
      cursor:splitVisualLines()
    end)
    ctx:forEachCursor(function(cursor)
      cursor:feedkeys(
        (cursor:atVisualStart() and '' or 'o')
          .. '<esc>'
          .. (mode == TERM_CODES.CTRL_V and '' or '<home>'), -- patch: from ^ to <home>
        { keycodes = true }
      )
    end)
  end)
  mc.feedkeys('i') -- patch: not use 'I' on ctrl-v mode
end)

vim.keymap.set('v', 'A', mc.appendVisual)

-- Increment/decrement sequences, treating all cursors as one sequence.
vim.keymap.set({ 'n', 'x' }, 'g<c-a>', mc.sequenceIncrement)
vim.keymap.set({ 'n', 'x' }, 'g<c-x>', mc.sequenceDecrement)

-- Add a cursor and jump to the next/previous search result.
-- stylua: ignore start
vim.keymap.set('n', '<leader>/n', function() mc.searchAddCursor(1) end)
vim.keymap.set('n', '<leader>/N', function() mc.searchAddCursor(-1) end)
vim.keymap.set('n', '<leader>/s', function() mc.searchSkipCursor(1) end)
vim.keymap.set('n', '<leader>/S', function() mc.searchSkipCursor(-1) end)
-- stylua: ignore end

-- Add a cursor to every search result in the buffer.
vim.keymap.set('n', '<leader>/A', mc.searchAllAddCursors)

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)
  -- Select a different cursor as the main one.
  layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
  layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

  -- Delete the main cursor.
  layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

  layerSet('n', '<leader>a', mc.alignCursors)

  -- Enable and clear cursors using escape.
  layerSet('n', '<esc>', function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)
