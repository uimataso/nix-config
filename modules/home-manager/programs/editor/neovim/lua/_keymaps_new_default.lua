-- Keymap that come from nvim 0.11 default
-- see: https://github.com/neovim/neovim/blob/master/runtime/lua/vim/_defaults.lua

--- Default maps for LSP functions.
---
--- These are mapped unconditionally to avoid different behavior depending on whether an LSP
--- client is attached. If no client is attached, or if a server does not support a capability, an
--- error message is displayed rather than exhibiting different behavior.
---
--- See |grr|, |grn|, |gra|, |gri|, |gO|, |i_CTRL-S|.
do
  vim.keymap.set('n', 'grn', function()
    vim.lsp.buf.rename()
  end, { desc = 'vim.lsp.buf.rename()' })

  vim.keymap.set({ 'n', 'x' }, 'gra', function()
    vim.lsp.buf.code_action()
  end, { desc = 'vim.lsp.buf.code_action()' })

  vim.keymap.set('n', 'grr', function()
    vim.lsp.buf.references()
  end, { desc = 'vim.lsp.buf.references()' })

  vim.keymap.set('n', 'gri', function()
    vim.lsp.buf.implementation()
  end, { desc = 'vim.lsp.buf.implementation()' })

  vim.keymap.set('n', 'gO', function()
    vim.lsp.buf.document_symbol()
  end, { desc = 'vim.lsp.buf.document_symbol()' })

  vim.keymap.set({ 'i', 's' }, '<C-S>', function()
    vim.lsp.buf.signature_help()
  end, { desc = 'vim.lsp.buf.signature_help()' })
end

--- Map [d and ]d to move to the previous/next diagnostic. Map <C-W>d to open a floating window
--- for the diagnostic under the cursor.
---
--- See |[d-default|, |]d-default|, and |CTRL-W_d-default|.
do
  -- vim.keymap.set('n', ']d', function()
  --   vim.diagnostic.jump({ count = vim.v.count1 })
  -- end, { desc = 'Jump to the next diagnostic in the current buffer' })
  --
  -- vim.keymap.set('n', '[d', function()
  --   vim.diagnostic.jump({ count = -vim.v.count1 })
  -- end, { desc = 'Jump to the previous diagnostic in the current buffer' })
  --
  -- vim.keymap.set('n', ']D', function()
  --   vim.diagnostic.jump({ count = math.huge, wrap = false })
  -- end, { desc = 'Jump to the last diagnostic in the current buffer' })
  --
  -- vim.keymap.set('n', '[D', function()
  --   vim.diagnostic.jump({ count = -math.huge, wrap = false })
  -- end, { desc = 'Jump to the first diagnostic in the current buffer' })

  -- NOTE: using `goto_prev` and `goto_next` since we don't have `jump` in 0.10
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.goto_next()
  end, { desc = 'Jump to the next diagnostic in the current buffer' })

  vim.keymap.set('n', '[d', function()
    vim.diagnostic.goto_prev()
  end, { desc = 'Jump to the previous diagnostic in the current buffer' })

  vim.keymap.set('n', '<C-W>d', function()
    vim.diagnostic.open_float()
  end, { desc = 'Show diagnostics under the cursor' })

  vim.keymap.set(
    'n',
    '<C-W><C-D>',
    '<C-W>d',
    { remap = true, desc = 'Show diagnostics under the cursor' }
  )
end

--- vim-unimpaired style mappings. See: https://github.com/tpope/vim-unimpaired
do
  --- Execute a command and print errors without a stacktrace.
  --- @param opts table Arguments to |nvim_cmd()|
  local function cmd(opts)
    local ok, err = pcall(vim.api.nvim_cmd, opts, {})
    if not ok then
      vim.api.nvim_err_writeln(err:sub(#'Vim:' + 1))
    end
  end

  -- Quickfix mappings
  vim.keymap.set('n', '[q', function()
    cmd({ cmd = 'cprevious', count = vim.v.count1 })
  end, { desc = ':cprevious' })

  vim.keymap.set('n', ']q', function()
    cmd({ cmd = 'cnext', count = vim.v.count1 })
  end, { desc = ':cnext' })

  vim.keymap.set('n', '[Q', function()
    cmd({ cmd = 'crewind', count = vim.v.count ~= 0 and vim.v.count or nil })
  end, { desc = ':crewind' })

  vim.keymap.set('n', ']Q', function()
    cmd({ cmd = 'clast', count = vim.v.count ~= 0 and vim.v.count or nil })
  end, { desc = ':clast' })

  vim.keymap.set('n', '[<C-Q>', function()
    cmd({ cmd = 'cpfile', count = vim.v.count1 })
  end, { desc = ':cpfile' })

  vim.keymap.set('n', ']<C-Q>', function()
    cmd({ cmd = 'cnfile', count = vim.v.count1 })
  end, { desc = ':cnfile' })

  -- Location list mappings
  vim.keymap.set('n', '[l', function()
    cmd({ cmd = 'lprevious', count = vim.v.count1 })
  end, { desc = ':lprevious' })

  vim.keymap.set('n', ']l', function()
    cmd({ cmd = 'lnext', count = vim.v.count1 })
  end, { desc = ':lnext' })

  vim.keymap.set('n', '[L', function()
    cmd({ cmd = 'lrewind', count = vim.v.count ~= 0 and vim.v.count or nil })
  end, { desc = ':lrewind' })

  vim.keymap.set('n', ']L', function()
    cmd({ cmd = 'llast', count = vim.v.count ~= 0 and vim.v.count or nil })
  end, { desc = ':llast' })

  vim.keymap.set('n', '[<C-L>', function()
    cmd({ cmd = 'lpfile', count = vim.v.count1 })
  end, { desc = ':lpfile' })

  vim.keymap.set('n', ']<C-L>', function()
    cmd({ cmd = 'lnfile', count = vim.v.count1 })
  end, { desc = ':lnfile' })

  -- Argument list
  vim.keymap.set('n', '[a', function()
    cmd({ cmd = 'previous', count = vim.v.count1 })
  end, { desc = ':previous' })

  vim.keymap.set('n', ']a', function()
    -- count doesn't work with :next, must use range. See #30641.
    cmd({ cmd = 'next', range = { vim.v.count1 } })
  end, { desc = ':next' })

  vim.keymap.set('n', '[A', function()
    if vim.v.count ~= 0 then
      cmd({ cmd = 'argument', count = vim.v.count })
    else
      cmd({ cmd = 'rewind' })
    end
  end, { desc = ':rewind' })

  vim.keymap.set('n', ']A', function()
    if vim.v.count ~= 0 then
      cmd({ cmd = 'argument', count = vim.v.count })
    else
      cmd({ cmd = 'last' })
    end
  end, { desc = ':last' })

  -- Tags
  vim.keymap.set('n', '[t', function()
    -- count doesn't work with :tprevious, must use range. See #30641.
    cmd({ cmd = 'tprevious', range = { vim.v.count1 } })
  end, { desc = ':tprevious' })

  vim.keymap.set('n', ']t', function()
    -- count doesn't work with :tnext, must use range. See #30641.
    cmd({ cmd = 'tnext', range = { vim.v.count1 } })
  end, { desc = ':tnext' })

  vim.keymap.set('n', '[T', function()
    -- count doesn't work with :trewind, must use range. See #30641.
    cmd({ cmd = 'trewind', range = vim.v.count ~= 0 and { vim.v.count } or nil })
  end, { desc = ':trewind' })

  vim.keymap.set('n', ']T', function()
    -- :tlast does not accept a count, so use :trewind if count given
    if vim.v.count ~= 0 then
      cmd({ cmd = 'trewind', range = { vim.v.count } })
    else
      cmd({ cmd = 'tlast' })
    end
  end, { desc = ':tlast' })

  vim.keymap.set('n', '[<C-T>', function()
    -- count doesn't work with :ptprevious, must use range. See #30641.
    cmd({ cmd = 'ptprevious', range = { vim.v.count1 } })
  end, { desc = ' :ptprevious' })

  vim.keymap.set('n', ']<C-T>', function()
    -- count doesn't work with :ptnext, must use range. See #30641.
    cmd({ cmd = 'ptnext', range = { vim.v.count1 } })
  end, { desc = ':ptnext' })

  -- Buffers
  vim.keymap.set('n', '[b', function()
    cmd({ cmd = 'bprevious', count = vim.v.count1 })
  end, { desc = ':bprevious' })

  vim.keymap.set('n', ']b', function()
    cmd({ cmd = 'bnext', count = vim.v.count1 })
  end, { desc = ':bnext' })

  vim.keymap.set('n', '[B', function()
    if vim.v.count ~= 0 then
      cmd({ cmd = 'buffer', count = vim.v.count })
    else
      cmd({ cmd = 'brewind' })
    end
  end, { desc = ':brewind' })

  vim.keymap.set('n', ']B', function()
    if vim.v.count ~= 0 then
      cmd({ cmd = 'buffer', count = vim.v.count })
    else
      cmd({ cmd = 'blast' })
    end
  end, { desc = ':blast' })

  -- Add empty lines
  vim.keymap.set('n', '[<Space>', function()
    -- TODO: update once it is possible to assign a Lua function to options #25672
    vim.go.operatorfunc = "v:lua.require'vim._buf'.space_above"
    return 'g@l'
  end, { expr = true, desc = 'Add empty line above cursor' })

  vim.keymap.set('n', ']<Space>', function()
    -- TODO: update once it is possible to assign a Lua function to options #25672
    vim.go.operatorfunc = "v:lua.require'vim._buf'.space_below"
    return 'g@l'
  end, { expr = true, desc = 'Add empty line below cursor' })
end
