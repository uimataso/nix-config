local Org = require('uima.org')
local Date = require('orgmode.objects.date')

--------------------------------------------------------------------------------
-- Filters & placeholders
--------------------------------------------------------------------------------

--- Filename-safe slug: lowercase, non-alphanum runs -> `-`, trimmed.
local function slug(s)
  s = (s or ''):lower():gsub('[^%w]+', '-'):gsub('^-+', ''):gsub('-+$', '')
  return s
end

--- `HH-MM` extracted from a wrapped timestamp string (for file paths).
local function hm(s)
  local h, m = (s or ''):match('(%d%d):(%d%d)')
  return (h and m) and (h .. '-' .. m) or ''
end

--- `YYYY-MM-DD` extracted from a wrapped timestamp string (for file paths).
local function ymd(s)
  local y, mo, d = (s or ''):match('(%d%d%d%d)%-(%d%d)%-(%d%d)')
  return (y and mo and d) and (y .. '-' .. mo .. '-' .. d) or ''
end

--- Filters applied via `{{name:filter}}` to a prompted value.
local filters = { slug = slug, hm = hm, ymd = ymd }

--- Built-in `{{name}}` / `{{name:fmt}}` placeholders (mirroring org capture
--- expansions). Each takes (vars, fmt, full) and returns the replacement.
---   date / date:fmt   plain date       (default %Y-%m-%d)
---   time / time:fmt   plain time       (default %H:%M)
---   u / U             inactive date / date+time
---   t / T             active   date / date+time
---   author            resolve_author()
---   cursor            preserved (positioned after subst)
local placeholders = {
  cursor = function(_, _, full)
    return full
  end,
  date = function(_, fmt)
    return Date.today():format(fmt or '%Y-%m-%d')
  end,
  time = function(_, fmt)
    return Date.now():format(fmt or '%H:%M')
  end,
  u = function()
    return Date.today():to_wrapped_string(false)
  end,
  U = function()
    return Date.now():to_wrapped_string(false)
  end,
  t = function()
    return Date.today():to_wrapped_string(true)
  end,
  T = function()
    return Date.now():to_wrapped_string(true)
  end,
  author = function(vars)
    return vars.author or ''
  end,
}

--- Expand `{{...}}` placeholders in `text` using `vars` (prompted values).
local function subst(text, vars)
  return (
    text:gsub('{{([^}]+)}}', function(inner, full)
      local name, fmt = inner:match('^(%w+):(.*)$')
      name = name or inner
      local builtin = placeholders[name]
      if builtin then
        return builtin(vars, fmt, full)
      end
      if fmt and filters[fmt] then
        return filters[fmt](vars[name] or '')
      end
      if vars[inner] ~= nil then
        return vars[inner]
      end
      if vars[name] ~= nil then
        return vars[name]
      end
      return ''
    end)
  )
end

--------------------------------------------------------------------------------
-- Parsing
--------------------------------------------------------------------------------

--- `#+` directives configuring the engine; anything else starts the body.
local directives = {
  key = function(meta, v)
    meta.key = v
  end,
  desc = function(meta, v)
    meta.desc = v
  end,
  target = function(meta, v)
    meta.target = v
  end,
  prompt = function(meta, v)
    local name, rest = v:match('^(%w+)=(.*)$')
    if not name then
      return
    end
    local label, default = rest:match('^(.-)%|(.*)$')
    table.insert(meta.prompts, {
      name = name,
      label = label or rest,
      default = default,
    })
  end,
}

--- Parse a template file. Leading `#+key/desc/target/prompt` directives
--- configure the engine; the rest is the body skeleton.
local function parse(path)
  local lines = vim.fn.readfile(path)
  local meta = { prompts = {}, file = path }
  local body_start
  for i, line in ipairs(lines) do
    local k, v = line:match('^%s*#%+(%w+):%s*(.*)$')
    local handler = k and directives[k:lower()]
    if not handler then
      body_start = i
      break
    end
    handler(meta, v)
  end
  body_start = body_start or (#lines + 1)
  -- drop leading blank lines (e.g. the separator before #+title)
  while body_start <= #lines and lines[body_start]:match('^%s*$') do
    body_start = body_start + 1
  end
  meta.body = table.concat(vim.list_slice(lines, body_start), '\n')
  return meta
end

local function load_all()
  local dir = Org.org_path('.templates')
  if vim.fn.isdirectory(dir) ~= 1 then
    return {}
  end
  local out = {}
  for _, name in ipairs(vim.fn.readdir(dir)) do
    if name:match('%.org$') then
      local meta = parse(dir .. '/' .. name)
      if meta.key then
        table.insert(out, meta)
      end
    end
  end
  table.sort(out, function(a, b)
    return a.key < b.key
  end)
  return out
end

--------------------------------------------------------------------------------
-- Target & prompting
--------------------------------------------------------------------------------

local function resolve_target(target)
  if target:match('^[/~]') then
    return vim.fn.expand(target)
  end
  return Org.org_dir .. '/' .. target
end

--- Open orgmode's calendar for a `@calendar` / `@calendar!` prompt.
--- `@calendar!` requires a time (hour+minute); on a date-only confirm it
--- reopens on the selected day until a time is set (or the user cancels).
local function gather_calendar(p, vars, on_done)
  local Calendar = require('orgmode.objects.calendar')
  local utils = require('orgmode.utils')
  local require_time = p.default == '@calendar!'
  local function open(date)
    Calendar.new({ date = date or Date.today(), title = p.label }):open():next(function(new_date)
      if new_date and require_time and new_date.date_only then
        utils.notify('Please enter hour and minutes (press t to set the time)', { level = 'warn' })
        return open(new_date)
      end
      vars[p.name] = new_date and new_date:to_wrapped_string(true) or ''
      on_done()
    end)
  end
  open()
end

--- Gather prompted inputs asynchronously, then call `on_done`.
local function gather(prompts, vars, on_done)
  local i = 1
  local function step()
    if i > #prompts then
      return on_done()
    end
    local p = prompts[i]
    i = i + 1
    if p.default == '@calendar' or p.default == '@calendar!' then
      return gather_calendar(p, vars, step)
    end
    vim.ui.input(
      { prompt = p.label .. ': ', default = subst(p.default or '', vars) },
      function(value)
        vars[p.name] = value or ''
        step()
      end
    )
  end
  step()
end

--------------------------------------------------------------------------------
-- Body filling
--------------------------------------------------------------------------------

--- Find the `{{cursor}}` marker: returns (row, col_before_marker) or nil.
local function find_cursor(lines)
  for idx, l in ipairs(lines) do
    local j = l:find('{{cursor}}', 1, true)
    if j then
      return idx, j - 1
    end
  end
end

--- Substitute `body` and write it into the current (empty) buffer, placing
--- the cursor at `{{cursor}}` or, if absent, at the start of the last line.
local function fill_body(body, vars)
  local lines = vim.split(subst(body, vars), '\n', { plain = true })
  local cur_row, cur_col = find_cursor(lines)
  if cur_row then
    lines[cur_row] = lines[cur_row]:gsub('{{cursor}}', '', 1)
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, { cur_row or #lines, cur_col or 0 })
end

--------------------------------------------------------------------------------
-- Apply
--------------------------------------------------------------------------------

--- Prompt for inputs, compute the target path, open it, and fill the body
--- into the empty buffer (the auto meta-header is skipped for this buffer).
local function apply(meta)
  local vars = { author = Org.resolve_author() }
  gather(meta.prompts, vars, function()
    local target = subst(meta.target or '', vars)
    if target == '' then
      return
    end
    local path = resolve_target(target)
    vim.fn.mkdir(vim.fs.dirname(path), 'p')
    Org.skip_next_header = true
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
    if Org.buf_is_empty(0) then
      fill_body(meta.body, vars)
    end
  end)
end

--------------------------------------------------------------------------------
-- Module
--------------------------------------------------------------------------------

local M = { subst = subst, parse = parse, load_all = load_all, apply = apply }

--- Register `<Leader>on<key>` for each template in `.templates/`.
function M.setup()
  for _, t in ipairs(load_all()) do
    vim.keymap.set('n', '<Leader>on' .. t.key, function()
      apply(t)
    end, { desc = 'org new: ' .. (t.desc or t.key) })
  end
end

return M
