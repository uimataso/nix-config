return {
  'chrishrb/gx.nvim',

  cmd = { 'Browse' },
  keys = {
    { 'gx', mode = { 'n', 'x' }, '<cmd>Browse<cr>' },
  },

  init = function()
    -- disable netrw gx
    vim.g.netrw_nogx = 1
  end,

  opts = {
    open_browser_app = 'xdg-open',
    handlers = {
      plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
      github = true, -- open github issues
      markdown = true,
      rust = {
        name = 'rust',
        filetype = { 'toml' },
        filename = 'Cargo.toml',
        handle = function(mode, line, _)
          local crate = require('gx.helper').find(line, mode, '(%w+)%s-=%s')
          if crate then
            return 'https://crates.io/crates/' .. crate
          end
        end,
      },
      shellcheck = {
        name = 'shellcheck',
        -- filetype = { 'bash', 'shell' },
        handle = function(mode, line, _)
          local error = require('gx.helper').find(line, mode, '%s*#%s*shellcheck%s+disable=(SC%d+)')
          if error then
            return 'https://www.shellcheck.net/wiki/' .. error
          end
        end,
      },
    },

    handler_options = {
      -- search_engine = 'duckduckgo', -- google, bing, duckduckgo, ecosia, yandex
      search_engine = 'https://search.uimataso.com/search?q=',
    },
  },
}
