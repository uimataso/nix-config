local function toggle_diffview(cmd)
  if next(require('diffview.lib').views) == nil then
    vim.cmd(cmd)
  else
    vim.cmd('DiffviewClose')
  end
end

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },

  keys = {
    {
      '<Leader>gd',
      mode = { 'n' },
      function()
        toggle_diffview('DiffviewOpen')
      end,
      desc = 'diff',
    },
    {
      '<Leader>gD',
      mode = { 'n' },
      function()
        toggle_diffview('DiffviewOpen master..HEAD')
      end,
      desc = 'diff master',
    },
    {
      '<Leader>gf',
      mode = { 'n' },
      function()
        toggle_diffview('DiffviewFileHistory %')
      end,
      desc = 'Open diffs for current File',
    },
  },

  opts = {
    enhanced_diff_hl = true,
  },
}
