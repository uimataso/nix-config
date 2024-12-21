local prettier = { 'prettierd', 'prettier', stop_after_first = true }

-- stealed from https://github.com/stevearc/dotfiles/blob/master/.config/nvim/lua/plugins/format.lua
---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  local conform = require('conform')
  for i = 1, select('#', ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },

  ---@type conform.setupOpts
  opts = {
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      html = prettier,
      javascript = prettier,
      lua = { 'stylua' },
      markdown = function(bufnr)
        return { first(bufnr, 'prettierd', 'prettier'), 'injected' }
      end,
      python = { 'isort', 'black' },
      yaml = { 'yamlfmt' },
    },
    format_on_save = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
    formatters = {
      yamlfmt = {
        -- https://github.com/google/yamlfmt/blob/main/docs/command-usage.md#configuration-flags
        prepend_args = { '-formatter', 'retain_line_breaks_single=true' },
      },
    },
  },
}
