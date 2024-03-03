return {
  'ten3roberts/qf.nvim',
  enabled = false,
  event = 'QuickFixCmdPre',
  opts = {
    -- Location list configuration
    l = {
      auto_close = true,      -- Automatically close location/quickfix list if empty
      auto_follow = 'prev',   -- Follow current entry, possible values: prev,next,nearest, or false to disable
      auto_follow_limit = 8,  -- Do not follow if entry is further away than x lines
      follow_slow = true,     -- Only follow on CursorHold
      auto_open = true,       -- Automatically open list on QuickFixCmdPost
      auto_resize = true,     -- Auto resize and shrink location list if less than `max_height`
      max_height = 8,         -- Maximum height of location/quickfix list
      min_height = 5,         -- Minimum height of location/quickfix list
      wide = false,           -- Open list at the very bottom of the screen, stretching the whole width.
      number = false,         -- Show line numbers in list
      relativenumber = false, -- Show relative line numbers in list
      unfocus_close = false,  -- Close list when window loses focus
      focus_open = false,     -- Auto open list on window focus if it contains items
    },
    -- Quickfix list configuration
    c = {
      auto_close = true,      -- Automatically close location/quickfix list if empty
      auto_follow = 'prev',   -- Follow current entry, possible values: prev,next,nearest, or false to disable
      auto_follow_limit = 8,  -- Do not follow if entry is further away than x lines
      follow_slow = true,     -- Only follow on CursorHold
      auto_open = true,       -- Automatically open list on QuickFixCmdPost
      auto_resize = true,     -- Auto resize and shrink location list if less than `max_height`
      max_height = 8,         -- Maximum height of location/quickfix list
      min_height = 5,         -- Minimum height of location/quickfix list
      wide = false,           -- Open list at the very bottom of the screen, stretching the whole width.
      number = false,         -- Show line numbers in list
      relativenumber = false, -- Show relative line numbers in list
      unfocus_close = false,  -- Close list when window loses focus
      focus_open = false,     -- Auto open list on window focus if it contains items
    },
    close_other = false,      -- Close location list when quickfix list opens
    pretty = true,            -- Pretty print quickfix lists
    silent = false,           -- Suppress messages like "(1 of 3): *line content*" on jump
  },
  keys = {
    { '<leader>co', function() require 'qf'.open('c') end },
    { '<leader>cc', function() require 'qf'.close('c') end },
    { '<leader>cl', function() require 'qf'.toggle('c', true) end },
  },
}
