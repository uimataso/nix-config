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
      rust = { -- custom handler to open rust's cargo packages
        name = 'rust', -- set name of handler
        filetype = { 'toml' }, -- you can also set the required filetype for this handler
        filename = 'Cargo.toml', -- or the necessary filename
        handle = function(mode, line, _)
          local crate = require('gx.helper').find(line, mode, '(%w+)%s-=%s')
          if crate then
            return 'https://crates.io/crates/' .. crate
          end
        end,
      },
    },
  },
}
