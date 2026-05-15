local M = {}

M.is_open = function(ty)
  if ty == 'quickfix' or ty == 'qf' then
    return M.is_quickfix_open()
  elseif ty == 'loclist' or ty == 'll' then
    return M.is_loclist_open()
  else
    error('ty must be one of: "quickfix", "qf", "loclist", "ll"')
  end
end

M.open = function(ty, opts)
  if ty == 'quickfix' or ty == 'qf' then
    vim.cmd.copen()
  elseif ty == 'loclist' or ty == 'll' then
    vim.cmd.lopen()
  else
    error('ty must be one of: "quickfix", "qf", "loclist", "ll"')
  end
end

M.close = function(ty)
  if ty == 'quickfix' or ty == 'qf' then
    vim.cmd.cclose()
  elseif ty == 'loclist' or ty == 'll' then
    vim.cmd.lclose()
  else
    error('ty must be one of: "quickfix", "qf", "loclist", "ll"')
  end
end

M.toggle = function(ty)
  if M.is_open(ty) then
    M.close(ty)
  else
    M.open(ty, {})
  end
end

M.is_quickfix_open = function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      return true
    end
  end
  return false
end

M.is_loclist_open = function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.loclist == 1 then
      return true
    end
  end
  return false
end

return M
