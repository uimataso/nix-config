return {
  'johmsalas/text-case.nvim',
  lazy = false,

  keys = {
    -- keymap example: <https://github.com/johmsalas/text-case.nvim?tab=readme-ov-file#example-in-vimscript-using-plug-with-custom-keybindings>
    -- - `<leader>cs`: to_snake_case
    -- - `<leader>cd`: to-dash-case
    -- - `<leader>cn`: TO_CONSTANT_CASE
    -- - `<leader>cc`: toCamelCase
    -- - `<leader>cp`: ToPascalCase
    '<leader>c',
  },

  cmd = {
    'Subs',
  },

  opts = {
    prefix = '<leader>c',
  },
}
