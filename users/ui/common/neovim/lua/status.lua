vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.laststatus = 3 -- global statusline
vim.opt.cmdheight = 0

-- Some shortmess work with cmdheight=0
vim.opt.shortmess:append('c')
vim.opt.shortmess:append('C')
vim.opt.shortmess:append('s')
vim.opt.shortmess:append('S')
vim.opt.shortmess:remove('t')

local hi = function(group)
  return '%#' .. group .. '#'
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
  return table.concat {
    '  ' .. git_info.head,
    added,
    changed,
    removed,
  }
end

local diagnostics = function()
  return table.concat {
    format_count(' %s', #(vim.diagnostic.get(0, { severity = 'Error' }))),
    format_count(' %s', #(vim.diagnostic.get(0, { severity = 'Warn' }))),
    format_count(' %s', #(vim.diagnostic.get(0, { severity = 'Info' }))),
    format_count(' %s', #(vim.diagnostic.get(0, { severity = 'Hint' }))),
  }
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
  if not ok or searchcount['total'] == 0 then
    return ''
  end

  return '  ' .. searchcount['current'] .. '∕' .. searchcount['total']
end


function Statusline()
  return table.concat({
    '  %t %h%m%r%w', -- Flie info
    vcs(),
    diagnostics(),

    '%=', -- Separation

    hi('MatchParen'),
    macro_recoding(),
    search_count(),
    hi('StatusLine'),
    '  %{&filetype}', -- Flietype
    '  %{&expandtab?"󱁐 ":"󰌒 "}%{&tabstop}', -- Indent info
    '  %L', -- Line info
    '  ',
  })
end

vim.opt.statusline = '%!v:lua.Statusline()'
