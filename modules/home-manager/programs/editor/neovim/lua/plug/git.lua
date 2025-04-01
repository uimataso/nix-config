return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 500,
        use_focus = true,
      },
      current_line_blame_formatter = '     <author>, <author_time:%R> - <summary>',

      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- stylua: ignore start
        map('n', '<leader>hs', gitsigns.stage_hunk, 'Stage hunk')
        map('n', '<leader>hr', gitsigns.reset_hunk, 'Reset hunk')
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Stage hunk')
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Reset hunk')

        map('n', '<leader>hS', gitsigns.stage_buffer, 'Stage buffer')
        map('n', '<leader>hu', gitsigns.stage_hunk, 'Undo stage hunk')
        map('n', '<leader>hR', gitsigns.reset_buffer, 'Reset buffer')
        map('n', '<leader>hp', gitsigns.preview_hunk, 'Preview hunk')

        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, 'Blame line')
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, 'Toggle current line blame')
        map('n', '<leader>hd', gitsigns.diffthis, 'Diffthis')
        map('n', '<leader>hD', function() gitsigns.diffthis('~') end, 'Diffthis')
        map('n', '<leader>td', gitsigns.preview_hunk_inline, 'Toggle deleted')
        -- stylua: ignore end
      end,
    },
  },

  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },

    cmd = 'Neogit',

    keys = {
      {
        '<Leader>git',
        mode = { 'n' },
        function()
          require('neogit').open()
        end,
        desc = 'Open neogit',
      },
    },

    opts = {
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
  },
}
