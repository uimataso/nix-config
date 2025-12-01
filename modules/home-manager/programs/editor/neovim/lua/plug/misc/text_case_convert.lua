return {
  'johmsalas/text-case.nvim',
  lazy = false,

  keys = {
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
