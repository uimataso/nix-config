return {
  'johmsalas/text-case.nvim',
  lazy = false,

  keys = {
    -- keymap example: <https://github.com/johmsalas/text-case.nvim?tab=readme-ov-file#example-in-vimscript-using-plug-with-custom-keybindings>
    -- - `gas`: to_snake_case
    -- - `gad`: to-dash-case
    -- - `gan`: TO_CONSTANT_CASE
    -- - `gac`: toCamelCase
    -- - `gap`: ToPascalCase
    'ga',
  },

  cmd = {
    -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
    'Subs',
    'TextCaseOpenTelescope',
    'TextCaseOpenTelescopeQuickChange',
    'TextCaseOpenTelescopeLSPChange',
    'TextCaseStartReplacingCommand',
  },

  opts = {},
}
