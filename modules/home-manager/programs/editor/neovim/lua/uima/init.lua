local M = {}

--- vim.api.nvim_create_augroup
---@param name string
---@param fn fun(au: fun(event, opts: vim.api.keyset.create_autocmd))
M.ag = function(name, fn)
  local group = vim.api.nvim_create_augroup(name, { clear = true })
  local au = function(event, opts)
    opts.group = group
    return vim.api.nvim_create_autocmd(event, opts)
  end
  fn(au)
end

--- Abbr for command mode
M.cabbrev = function(lhs, rhs)
  -- only working on ':' mode
  local command =
    "cnoreabbrev <expr> %s ((getcmdtype() is# ':' && getcmdline() is# '%s')?('%s'):('%s'))"
  vim.cmd(command:format(lhs, lhs, rhs, lhs))
end

M.lazy = function(event, pattern, f)
  vim.api.nvim_create_autocmd(event, {
    once = true,
    pattern = pattern,
    callback = f,
  })
end

---@param lists any[][]
---@return any[] merged_list
M.list_merge = function(lists)
  local ret = {}
  for _, list in pairs(lists) do
    vim.list_extend(ret, list)
  end
  return ret
end

--- Return the visually selected text as an array with an entry for each line
--- from: https://www.reddit.com/r/neovim/comments/1b1sv3a/function_to_get_visually_selected_text
--- @return string[]|nil lines The selected text as an array of lines.
M.get_selected_lines = function()
  local _, srow, scol = unpack(vim.fn.getpos('v'))
  local _, erow, ecol = unpack(vim.fn.getpos('.'))

  -- visual line mode
  if vim.fn.mode() == 'V' then
    if srow > erow then
      return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
    else
      return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
    end
  end

  -- regular visual mode
  if vim.fn.mode() == 'v' then
    if srow < erow or (srow == erow and scol <= ecol) then
      return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  end

  -- visual block mode
  if vim.fn.mode() == '\22' then
    local lines = {}
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      table.insert(
        lines,
        vim.api.nvim_buf_get_text(
          0,
          i - 1,
          math.min(scol - 1, ecol),
          i - 1,
          math.max(scol - 1, ecol),
          {}
        )[1]
      )
    end
    return lines
  end
end

M.get_selected_range = function()
  local a, b = vim.fn.line('v'), vim.fn.line('.')
  if a > b then
    a, b = b, a
  end
  return a, b
end

--- Un-indent given lines
---@param lines string[]
--- @return string[] lines
M.unindent = function(lines)
  local min_indent = nil

  for _, line in ipairs(lines) do
    local indent = line:match('^%s*')
    if #indent ~= #line then
      if min_indent == nil or #indent < min_indent then
        min_indent = #indent
      end
    end
  end

  if not min_indent then
    return lines
  end

  local result = {}
  for _, line in ipairs(lines) do
    if #line >= min_indent then
      table.insert(result, line:sub(min_indent + 1))
    else
      table.insert(result, line)
    end
  end
  return result
end

-- TODO: do i really need this?
--- overwrite the diagnostic highgroup with specify one
---@param diagnostic_ns integer
---@param highlight_ns integer | string
---@param highlight_group string
M.overwrite_diagnostic_highlight = function(diagnostic_ns, highlight_ns, highlight_group)
  if type(highlight_ns) == 'string' then
    highlight_ns = vim.api.nvim_create_namespace(highlight_ns)
  end

  -- add sepll highlight group
  vim.diagnostic.handlers[highlight_ns] = {
    show = function(namespace, bufnr, diagnostics, _)
      if namespace == diagnostic_ns then
        for _, diagnostic in ipairs(diagnostics) do
          vim.api.nvim_buf_add_highlight(
            bufnr,
            highlight_ns,
            highlight_group,
            diagnostic.lnum,
            diagnostic.col,
            diagnostic.end_col
          )
        end
      end
    end,
    hide = function(namespace, bufnr)
      if namespace == diagnostic_ns then
        vim.api.nvim_buf_clear_namespace(bufnr, highlight_ns, 0, -1)
      end
    end,
  }

  local filter_diagnostics = function(diagnostics)
    local filtered_diagnostics = {}
    for _, d in pairs(diagnostics) do
      if d.namespace ~= diagnostic_ns then
        table.insert(filtered_diagnostics, d)
      end
    end
    return filtered_diagnostics
  end

  local orig_signs_handler = vim.diagnostic.handlers.signs
  vim.diagnostic.handlers.signs = {
    show = function(ns, bufnr, dias, opts)
      orig_signs_handler.show(ns, bufnr, filter_diagnostics(dias), opts)
    end,
    hide = orig_signs_handler.hide,
  }

  local orig_underline_handler = vim.diagnostic.handlers.underline
  vim.diagnostic.handlers.underline = {
    show = function(ns, bufnr, dias, opts)
      orig_underline_handler.show(ns, bufnr, filter_diagnostics(dias), opts)
    end,
    hide = orig_underline_handler.hide,
  }
end

return M
