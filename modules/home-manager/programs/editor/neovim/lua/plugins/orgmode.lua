-- default config: https://github.com/nvim-orgmode/orgmode/blob/master/lua/orgmode/config/defaults.lua

local Org = require('uima.org')
local capture = require('uima.org.capture')
local org_path = Org.org_path

vim.pack.add({
  { src = 'https://github.com/nvim-orgmode/orgmode' },
}, { load = true })

require('orgmode').setup({
  org_agenda_files = org_path('**/*'),
  org_default_notes_file = org_path('inbox.org'),

  org_startup_folded = 'content',
  org_startup_indented = true,

  mappings = { global = { org_capture = false } },

  org_capture_templates = {
    t = {
      description = 'Inbox',
      template = capture.with_selection(
        '* TODO %?\nDEADLINE: %T\n:PROPERTIES:\n:CREATED: %u\n:END:'
      ),
    },
    T = {
      description = 'Todo',
      template = capture.with_selection(
        '* TODO %?\nDEADLINE: %T\n:PROPERTIES:\n:CREATED: %u\n:END:'
      ),
      target = org_path('todos.org'),
    },
    r = {
      description = 'Quick note',
      template = capture.with_selection('* TODO %? :REVISIT:\n:PROPERTIES:\n:CREATED: %u\n:END:'),
    },
  },
})

vim.lsp.enable('org')

local ag = require('uima').ag

-- Stash the active selection, then open the capture prompt.
vim.keymap.set({ 'n', 'x' }, '<Leader>oc', function()
  capture.capture()
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
      if vim.bo[buf].buftype == '' and Org.buf_is_empty(buf) then
        Org.insert_meta_header(buf, vim.api.nvim_buf_get_name(buf))
      end
    end,
  })
end)
