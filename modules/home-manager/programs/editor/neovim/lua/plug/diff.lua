local function toggle_diffview(cmd)
  if next(require('diffview.lib').views) == nil then
    vim.cmd(cmd)
  else
    vim.cmd('DiffviewClose')
  end
end

local select_next_entry = function()
  require('diffview.actions').select_next_entry()
end
local select_prev_entry = function()
  require('diffview.actions').select_prev_entry()
end

return {
  'dlyongemallo/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },

  keys = {
    -- stylua: ignore start
    { '<M-d>',      mode = { 'n' }, function() toggle_diffview('DiffviewOpen') end, desc = 'diff' },
    { '<Leader>gd', mode = { 'n' }, function() toggle_diffview('DiffviewOpen') end, desc = 'diff' },
    { '<Leader>gD', mode = { 'n' }, function() toggle_diffview('DiffviewOpen master..HEAD') end, desc = 'diff master' },
    { '<Leader>gf', mode = { 'n' }, function() toggle_diffview('DiffviewFileHistory %') end, desc = 'Open diffs for current File' },
    -- stylua: ignore end
  },

  opts = {
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
        { 'n', '<c-j>', select_next_entry, { desc = 'Next entry' } },
        { 'n', '<c-k>', select_prev_entry, { desc = 'Prev entry' } },
        ['<tab>'] = false,
        ['<s-tab>'] = false,
      },
      file_panel = {
        { 'n', 'q', '<Cmd>DiffviewClose<CR>' },
        { 'n', '<c-j>', select_next_entry, { desc = 'Next entry' } },
        { 'n', '<c-k>', select_prev_entry, { desc = 'Prev entry' } },
        ['<tab>'] = false,
        ['<s-tab>'] = false,
      },
      file_history_panel = {
        { 'n', 'q', '<Cmd>DiffviewClose<CR>' },
        { 'n', '<c-j>', select_next_entry, { desc = 'Next entry' } },
        { 'n', '<c-k>', select_prev_entry, { desc = 'Prev entry' } },
        ['<tab>'] = false,
        ['<s-tab>'] = false,
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
  },
}
