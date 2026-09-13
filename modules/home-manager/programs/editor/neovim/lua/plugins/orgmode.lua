-- default config: https://github.com/nvim-orgmode/orgmode/blob/master/lua/orgmode/config/defaults.lua

local org_path = function(path)
  local org_dir = '/share/notes'
  return ('%s/%s'):format(org_dir, path)
end

vim.pack.add({
  { src = 'https://github.com/nvim-orgmode/orgmode' },
}, { load = true })

-- Helpers

local function org_date()
  return os.date('%Y-%m-%d')
end

---@param path string
---@return string
local function title_from_path(path)
  local stem = vim.fs.basename(path):gsub('%.org$', '')
  stem = stem:gsub('[-_]+', ' ')
  return (stem:gsub('%f[%w]%w', function(c)
    return c:upper()
  end))
end

---@return string
local function resolve_author()
  local name = vim.fn.system({ 'git', 'config', 'user.name' })
  name = vim.trim(name)
  if name == '' or vim.v.shell_error ~= 0 then
    return vim.env.USER or ''
  end
  return name
end

local function insert_meta_header(bufnr, path)
  local lines = {
    '#+title: ' .. title_from_path(path),
    '#+author: ' .. resolve_author(),
    '#+date: ' .. org_date(),
    '',
  }
  -- replace the (empty) buffer contents
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  -- place cursor at the end of the file, normal mode
  if vim.api.nvim_win_get_buf(0) == bufnr then
    vim.api.nvim_win_set_cursor(0, { #lines, 0 })
  end
end

local function buf_is_empty(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return #lines == 0 or (#lines == 1 and lines[1] == '')
end

--- Exposed on _G so org capture template expressions can drain it.
local OrgCapture = {}

function OrgCapture.capture()
  local U = require('uima')
  local lines = U.get_selected_lines()
  if not lines then
    OrgCapture._stash = nil
    return
  end
  local a, b = U.get_selected_range()
  local path = vim.fn.expand('%:p')
  local cwd = (vim.uv and vim.uv.cwd() or vim.loop.cwd()) .. '/'
  local rel = path:gsub('^' .. vim.pesc(cwd), '')
  local ft = vim.bo.filetype
  OrgCapture._stash = {
    text = table.concat(U.unindent(lines), '\n'),
    ft = (ft and ft ~= '') and ft or 'text',
    path = path, -- absolute: orgmode only resolves /abs, ~/, ./, ../
    rel = rel, -- short display text, relative to cwd
    a = a,
    b = b,
  }
end

--- Returns '' when nothing was stashed (e.g. capture from normal mode).
function OrgCapture.drain_selection()
  local s = OrgCapture._stash
  OrgCapture._stash = nil
  if not s then
    return ''
  end
  local range_str = s.a == s.b and tostring(s.a) or (s.a .. '-' .. s.b)
  local link = ('[[file:%s::%d][%s:%s]]'):format(s.path, s.a, s.rel, range_str)
  local block = ('#+begin_src %s\n%s\n#+end_src'):format(s.ft, s.text)
  return '\n' .. link .. '\n' .. block
end

_G.OrgCapture = OrgCapture

local function with_selection(template)
  return template .. '\n%(return _G.OrgCapture.drain_selection())'
end

-- Setup

require('orgmode').setup({
  org_agenda_files = org_path('**/*'),
  org_default_notes_file = org_path('inbox.org'),

  org_startup_folded = 'content',
  org_startup_indented = true,

  mappings = { global = { org_capture = false } },

  org_capture_templates = {
    t = {
      description = 'Inbox',
      template = with_selection('* TODO %?\nDEADLINE: %T\n:PROPERTIES:\n:CREATED: %u\n:END:'),
    },
    T = {
      description = 'Todo',
      template = with_selection('* TODO %?\nDEADLINE: %T\n:PROPERTIES:\n:CREATED: %u\n:END:'),
      target = org_path('todos.org'),
    },
    r = {
      description = 'Quick note',
      template = with_selection('* TODO %? :REVISIT:\n:PROPERTIES:\n:CREATED: %u\n:END:'),
    },
  },
})

-- Experimental LSP support
vim.lsp.enable('org')

local ag = require('uima').ag

-- Stash the active selection, then open the capture prompt.
vim.keymap.set({ 'n', 'x' }, '<Leader>oc', function()
  OrgCapture.capture()
  require('orgmode').action('capture.prompt')
end, { desc = 'org capture' })

ag('uima/OrgMode', function(au)
  -- Insert-mode meta return
  au('FileType', {
    pattern = 'org',
    callback = function(args)
      vim.keymap.set('i', '<S-CR>', function()
        require('orgmode').action('org_mappings.meta_return')
      end, { buffer = args.buf, silent = true, desc = 'org meta return' })
    end,
  })

  -- Auto-insert metadata header for empty org buffers.
  au('FileType', {
    pattern = 'org',
    callback = function(args)
      local buf = args.buf
      if vim.bo[buf].buftype == '' and buf_is_empty(buf) then
        insert_meta_header(buf, vim.api.nvim_buf_get_name(buf))
      end
    end,
  })
end)
