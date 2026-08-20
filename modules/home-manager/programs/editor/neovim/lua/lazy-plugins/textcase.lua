vim.pack.add({
  'https://github.com/johmsalas/text-case.nvim',
})

local textcase = require('textcase')
local prefix = '<leader>c'

textcase.setup({
  prefix = prefix,
  default_keymappings_enabled = false,
})

-- custom keymaps instead of textcase's defaults, for desc
local cases = {
  { method = 'to_constant_case', key = 'n', example = 'TO_CONSTANT_CASE' },
  { method = 'to_camel_case', key = 'c', example = 'toCamelCase' },
  { method = 'to_snake_case', key = 's', example = 'to_snake_case' },
  { method = 'to_dash_case', key = 'd', example = 'to-dash-case' },
  { method = 'to_pascal_case', key = 'p', example = 'ToPascalCase' },
  { method = 'to_upper_case', key = 'u', example = 'TO UPPER CASE' },
  { method = 'to_lower_case', key = 'l', example = 'to lower case' },
}

for _, c in ipairs(cases) do
  vim.keymap.set({ 'n', 'x' }, prefix .. c.key, function()
    textcase.quick_replace(c.method)
  end, { desc = c.example })

  vim.keymap.set('n', prefix .. c.key:upper(), function()
    textcase.lsp_rename(c.method)
  end, { desc = c.example .. ' (LSP)' })

  vim.keymap.set('n', prefix .. 'o' .. c.key, function()
    textcase.operator(c.method)
  end, { desc = c.example .. ' (operator)' })
end
