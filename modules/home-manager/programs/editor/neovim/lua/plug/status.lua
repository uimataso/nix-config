vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.laststatus = 3 -- global statusline
vim.opt.cmdheight = 1
vim.opt.statusline = '%!v:lua.Statusline()'

-- -- Some shortmess work with cmdheight=0
-- vim.opt.shortmess:append('c')
-- vim.opt.shortmess:append('C')
-- vim.opt.shortmess:append('s')
-- vim.opt.shortmess:append('S')
-- vim.opt.shortmess:remove('t')

local hi = function(group)
  return '%#' .. group .. '#'
end

local with_hi = function(group, tables)
  return table.concat({
    hi(group),
    table.concat(tables),
    hi('StatusLine'),
  })
end

local format_count = function(format, count)
  if not count or count == 0 then
    return ''
  end
  return string.format(format, count)
end

local vcs = function()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == '' then
    return ''
  end
  local added = format_count(' +%s', git_info.added)
  local changed = format_count(' ~%s', git_info.changed)
  local removed = format_count(' -%s', git_info.removed)
  return table.concat({
    '  ' .. git_info.head,
    added,
    changed,
    removed,
  })
end

local diagnostics = function()
  local format_diagnostic_count = function(level)
    local sign = require('config').signs.diagnostic[level]
    return format_count(' ' .. sign .. '%s', #(vim.diagnostic.get(0, { severity = level })))
  end

  local severity = vim.diagnostic.severity
  return table.concat({
    format_diagnostic_count(severity.ERROR),
    format_diagnostic_count(severity.WARN),
    format_diagnostic_count(severity.INFO),
    format_diagnostic_count(severity.HINT),
  })
end

local macro_recoding = function()
  if vim.fn.reg_recording() == '' then
    return ''
  end
  return '  @' .. vim.fn.reg_recording()
end

local search_count = function()
  if vim.v.hlsearch ~= 1 then
    return ''
  end

  local ok, searchcount = pcall(vim.fn.searchcount)
  if not ok or not next(searchcount) or searchcount['total'] == 0 then
    return ''
  end

  return '  ' .. searchcount['current'] .. '∕' .. searchcount['total']
end

function Statusline()
  return table.concat({
    '  %t %h%m%r%w', -- File info
    vcs(),
    diagnostics(),
    '%=', -- Separation
    with_hi('MatchParen', {
      macro_recoding(),
      search_count(),
    }),
    '  %{&filetype}', -- Flietype
    '  %{&expandtab?"󱁐 ":"󰌒 "}%{&tabstop}', -- Indent info
    '  %L', -- Line info
    '  ',
  })
end

return {}
