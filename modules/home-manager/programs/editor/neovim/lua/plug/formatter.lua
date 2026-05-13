local au = require('utils').au
local ag = require('utils').ag

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

ag('uima/CargoSort', function(g)
  au({ 'BufWritePost' }, {
    group = g,
    pattern = '*.rs',
    callback = function(event)
      local root = vim.fs.root(event.buf, { 'Cargo.toml' })
      if not root then
        return
      end
      vim.system({ 'cargo', 'sort', '--grouped', '--workspace' })
    end,
  })
end)

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },

  ---@module 'conform.nvim'
  ---@type conform.setupOpts
  opts = {
    default_format_opts = {
      lsp_format = 'fallback',
    },

    formatters_by_ft = {
      html = { 'superhtml' },
      javascript = { 'prettier' },
      markdown = { 'injected' },
      json = { 'fixjson' },

      yaml = { 'yamlfmt' },
      -- toml = { 'taplo' },

      lua = { 'stylua' },
      python = { 'isort', 'black' },
      nix = { 'nixfmt' },

      -- ['*'] = { 'trim_whitespace', 'trim_newlines' },
    },

    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,

    formatters = {
      yamlfmt = {
        -- https://github.com/google/yamlfmt/blob/main/docs/command-usage.md#configuration-flags
        prepend_args = { '-formatter', 'retain_line_breaks_single=true' },
      },
    },
  },
}
