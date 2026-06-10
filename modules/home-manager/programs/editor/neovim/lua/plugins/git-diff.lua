vim.pack.add({
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/dlyongemallo/diffview.nvim',
  -- dep
  'https://github.com/nvim-mini/mini.pick',
  'https://github.com/m00qek/baleia.nvim',
}, { load = true })

require('mini.pick').setup()

require('neogit').setup({
  commit_editor = {
    staged_diff_split_kind = 'auto',
  },
  integrations = {
    fzf_lua = false,
  },
})

require('gitsigns').setup({
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 500,
    use_focus = true,
  },
  current_line_blame_formatter = '     <author>, <author_time:%R> - <summary>',
})

require('diffview').setup({
  show_help_hints = false,
  enhanced_diff_hl = true,
  diffopt = { algorithm = 'histogram' },

  view = {
    cycle_layouts = {
      default = { 'diff2_horizontal', 'diff2_vertical', 'diff1_inline' },
    },
  },

  keymaps = {
    view = {
      { 'n', 'q', '<Cmd>DiffviewClose<CR>' },
    },
    file_panel = {
      { 'n', 'q', '<Cmd>DiffviewClose<CR>' },
    },
    file_history_panel = {
      { 'n', 'q', '<Cmd>DiffviewClose<CR>' },
    },
  },

  hooks = {
    diff_buf_read = function()
      vim.opt_local.wrap = false
    end,
    -- from: https://github.com/sindrets/dotfiles/blob/master/.config/nvim/lua/user/plugins/diffview.lua
    ---@diagnostic disable-next-line: unused-local
    diff_buf_win_enter = function(bufnr, winid, ctx)
      -- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on the right.
      if ctx.layout_name:match('^diff2') then
        if ctx.symbol == 'a' then
          vim.opt_local.winhl = table.concat({
            'DiffAdd:DiffDelete',
            'DiffDelete:DiffviewDiffDeleteDim',
            'DiffChange:DiffDelete',
            'DiffText:DiffTextDelete',
            'DiffTextAdd:DiffTextDelete',
          }, ',')
        elseif ctx.symbol == 'b' then
          vim.opt_local.winhl = table.concat({
            'DiffDelete:DiffviewDiffDeleteDim',
            'DiffChange:DiffAdd',
            'DiffText:DiffTextAdd',
          }, ',')
        end
      end
    end,
  },
})

local function toggle_dv(cmd)
  return function()
    if next(require('diffview.lib').views) == nil then
      vim.cmd(cmd)
    else
      vim.cmd('DiffviewClose')
    end
  end
end

vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>')

-- blame
vim.keymap.set('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<cr>')
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns blame_line full=true<cr>')
vim.keymap.set('n', '<leader>gB', '<cmd>Gitsigns blame<cr>')

-- text object
vim.keymap.set({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<cr>')

-- inline diff
vim.keymap.set('n', '<leader>tw', '<cmd>Gitsigns toggle_word_diff<cr>')
vim.keymap.set('n', '<leader>tl', '<cmd>Gitsigns toggle_linehl<cr>')
vim.keymap.set('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<cr>')

-- diff view
vim.keymap.set('n', '<Leader>dw', toggle_dv('DiffviewOpen'), { desc = 'diff working tree' })
-- this diff the whole working tree tho
vim.keymap.set('n', '<Leader>du', toggle_dv('DiffviewOpen'), { desc = 'diff unstaged' })
vim.keymap.set('n', '<Leader>ds', toggle_dv('DiffviewOpen --staged'), { desc = 'diff staged' })
vim.keymap.set('n', '<Leader>dh', toggle_dv('DiffviewFileHistory %'), { desc = 'diff cur file' })

-- fuzzy
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<cr>')
vim.keymap.set('n', '<leader>gS', '<cmd>FzfLua git_stash<cr>')

-- stage
vim.keymap.set('n', '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>')
vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>')

vim.keymap.set('v', '<leader>gs', function()
  require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end)
vim.keymap.set('v', '<leader>gr', function()
  require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end)

vim.keymap.set('n', '<leader>gS', '<cmd>Gitsigns stage_buffer<cr>')
vim.keymap.set('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>')

-- Navigation
vim.keymap.set('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
  else
    require('gitsigns').nav_hunk('next')
  end
end)

vim.keymap.set('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ '[c', bang = true })
  else
    require('gitsigns').nav_hunk('prev')
  end
end)

-- preview hunk
vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>')
vim.keymap.set('n', '<leader>gi', '<cmd>Gitsigns preview_hunk_inline<cr>')

-- quickfix
vim.keymap.set('n', '<leader>gq', '<cmd>Gitsigns setqflist all<cr>')
vim.keymap.set('n', '<leader>gQ', '<cmd>Gitsigns setqflist<cr>')
