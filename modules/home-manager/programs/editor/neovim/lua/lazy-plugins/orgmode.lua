vim.pack.add({
  { src = 'https://github.com/nvim-orgmode/orgmode' },
})

require('orgmode').setup({
  org_agenda_files = '/share/notes/**/*',
  org_default_notes_file = '/share/notes/refile.org',
})

-- Experimental LSP support
vim.lsp.enable('org')
