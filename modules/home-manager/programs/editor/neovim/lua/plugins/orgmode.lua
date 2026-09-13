-- default config: https://github.com/nvim-orgmode/orgmode/blob/master/lua/orgmode/config/defaults.lua

local org_path = function(path)
  local org_dir = '/share/notes'
  return ('%s/%s'):format(org_dir, path)
end

vim.pack.add({
  { src = 'https://github.com/nvim-orgmode/orgmode' },
}, { load = true })

require('orgmode').setup({
  org_agenda_files = org_path('**/*'),
  org_default_notes_file = org_path('inbox.org'),

  -- org_startup_folded = 'content',
  org_startup_indented = true,

  org_capture_templates = {
    t = {
      description = 'Refile',
      template = '* TODO %?\nDEADLINE: %T',
    },
    T = {
      description = 'Todo',
      template = '* TODO %?\nDEADLINE: %T',
      target = org_path('todos.org'),
    },
    r = {
      description = 'Quick note',
      template = '* TODO %? :REVISIT:',
    },
  },
})

-- Experimental LSP support
vim.lsp.enable('org')

--- Format a plain ISO date (YYYY-MM-DD), matching Emacs org `#+date:`.
local function org_date()
  return os.date('%Y-%m-%d')
end

--- Title-case a filename stem into a human title.
---@param path string
---@return string
local function title_from_path(path)
  local stem = vim.fs.basename(path):gsub('%.org$', '')
  stem = stem:gsub('[-_]+', ' ')
  return (stem:gsub('%f[%w]%w', function(c)
    return c:upper()
  end))
end

--- Resolve author from git config user.name, falling back to $USER.
---@return string
local function resolve_author()
  local name = vim.fn.system({ 'git', 'config', 'user.name' })
  name = vim.trim(name)
  if name == '' or vim.v.shell_error ~= 0 then
    return vim.env.USER or ''
  end
  return name
end

--- Insert an org file metadata header (title/author/date) into an empty org buffer.
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

--- True when the buffer holds no non-blank content.
local function buf_is_empty(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return #lines == 0 or (#lines == 1 and lines[1] == '')
end

local ag = require('uima').ag

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
