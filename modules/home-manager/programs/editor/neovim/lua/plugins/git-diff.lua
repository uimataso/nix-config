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
vim.keymap.set('n', '<leader>vw', '<cmd>Gitsigns toggle_word_diff<cr>')
vim.keymap.set('n', '<leader>vl', '<cmd>Gitsigns toggle_linehl<cr>')
vim.keymap.set('n', '<leader>vd', '<cmd>Gitsigns toggle_deleted<cr>')

vim.keymap.set('n', '<M-d>', toggle_dv('DiffviewOpen'), { desc = 'diff' })
vim.keymap.set('n', '<Leader>gd', toggle_dv('DiffviewOpen'), { desc = 'diff' })
vim.keymap.set('n', '<Leader>gD', toggle_dv('DiffviewOpen master..HEAD'), { desc = 'diff master' })
vim.keymap.set('n', '<Leader>gf', toggle_dv('DiffviewFileHistory %'), { desc = 'diff cur file' })

vim.keymap.set('n', '<leader>gb', '<cmd>FzfLua git_branches<cr>')
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_commits<cr>')
vim.keymap.set('n', '<leader>gC', '<cmd>FzfLua git_bcommits<cr>')
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<cr>')
vim.keymap.set('n', '<leader>gS', '<cmd>FzfLua git_stash<cr>')
