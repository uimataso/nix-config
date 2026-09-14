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

  org_todo_keywords = { 'TODO(t)', 'PROGRESS(p)', '|', 'DONE(d)', 'REJECTED(r)' },
  org_startup_folded = 'inherit',
  org_adapt_indentation = false,

  mappings = { global = { org_capture = false } },

  org_capture_templates = {
    n = {
      description = 'Add note',
      template = capture.with_selection('* %?\n:PROPERTIES:\n:CREATED: %u\n:END:'),
    },
    t = {
      description = 'Add todo',
      template = capture.with_selection(
        '* TODO %?\nDEADLINE: %T\n:PROPERTIES:\n:CREATED: %u\n:END:'
      ),
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
  au('FileType', {
    pattern = 'org',
    callback = function(args)
      -- Insert-mode meta return
      vim.keymap.set('i', '<S-CR>', function()
        require('orgmode').action('org_mappings.meta_return')
      end, { buffer = args.buf, silent = true, desc = 'org meta return' })
    end,
  })

  -- Auto-insert metadata header for empty org buffers.
  au('FileType', {
    pattern = 'org',
    callback = function(args)
      -- The template engine provides its own header for the buffer it opens.
      if Org.skip_next_header then
        Org.skip_next_header = false
        return
      end
      local buf = args.buf
      if vim.bo[buf].buftype == '' and Org.buf_is_empty(buf) then
        Org.insert_meta_header(buf, vim.api.nvim_buf_get_name(buf))
      end
    end,
  })
end)

-- `<Leader>on<key>`: create a new note from a template in `.templates/`.
require('uima.org.template').setup()
