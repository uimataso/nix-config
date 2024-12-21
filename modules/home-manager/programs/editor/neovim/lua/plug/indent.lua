vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true

return {
  'nmac427/guess-indent.nvim',
  event = 'BufReadPost',
  config = true,
}
