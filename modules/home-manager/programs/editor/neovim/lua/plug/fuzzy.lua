return {
  {
    'folke/snacks.nvim',

    keys = {
      -- stylua: ignore start
      { '=', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
      { 'z=', function() Snacks.picker.spelling() end, desc = 'Spell suggest' },

      { "<Leader>fs", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fw", mode = { "n", "x" }, function()
        Snacks.picker.grep_word() end, desc = "Visual selection or word" },
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },

      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },

      { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>fT", function() Snacks.picker.todo_comments({
        keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },

      { "<leader>he", function() Snacks.picker.help() end, desc = "Help Pages" },

      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- stylua: ignore end
    },

    ---@type snacks.Config
    opts = {
      picker = {},
    },
  },

  {
    'ibhagwan/fzf-lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    command = 'FzfLua',

    keys = {
      { 'gra', '<cmd>FzfLua lsp_code_actions<cr>' },
      { '<Leader>a', '<cmd>FzfLua lsp_code_actions<cr>' },
      { '<C-x><C-p>', mode = 'i', '<cmd>FzfLua complete_path<cr>' },
      { '<C-x><C-f>', mode = 'i', '<cmd>FzfLua complete_file<cr>' },
      { '<C-x><C-l>', mode = 'i', '<cmd>FzfLua complete_line<cr>' },
    },

    config = function(_, opts)
      require('fzf-lua').setup(opts)
      -- require('fzf-lua').register_ui_select()
    end,
  },

  {
    'bassamsdata/namu.nvim',
    lazy = false,

    keys = {
      { '<leader>ss', mode = 'n', ':Namu symbols<cr>', desc = 'Jump to LSP symbol' },
    },

    opts = {
      -- Enable the modules you want
      namu_symbols = {
        enable = true,
        options = {}, -- here you can configure namu
      },

      ui_select = { enable = false }, -- vim.ui.select() wrapper
    },
  },
}
