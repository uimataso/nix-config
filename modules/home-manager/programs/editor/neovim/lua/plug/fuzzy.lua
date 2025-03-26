return {
  {
    'folke/snacks.nvim',

    keys = {
      -- stylua: ignore start
      { '=', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
      { 'z=', function() Snacks.picker.spelling() end, desc = 'Spell suggest' },

      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },

      { "<Leader>fs", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fw", mode = { "n", "x" }, function()
        Snacks.picker.grep_word() end, desc = "Visual selection or word" },
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },

      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },

      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gry", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
      { "gro", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "grO", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

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
      picker = {
        -- Flash integration
        win = {
          input = {
            keys = {
              ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
              ['s'] = { 'flash' },
            },
          },
        },
        actions = {
          flash = function(picker)
            require('flash').jump({
              pattern = '^',
              label = { after = { 0, 0 } },
              search = {
                mode = 'search',
                exclude = {
                  function(win)
                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                  end,
                },
              },
              action = function(match)
                local idx = picker.list:row2idx(match.pos[1])
                picker.list:_move(idx, true, true)
              end,
            })
          end,
        },
      },
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
}
