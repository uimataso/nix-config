local function cargo_build(cmd)
  local lines = vim.fn.systemlist(cmd)
  local output = table.concat(lines, 'n')
  local filename = output:match('^.*"executable":"(.*)",.*n.*,"success":true}$')

  if filename == nil then
    return error('failed to build cargo project')
  end

  return filename
end

return {
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    ft = 'rust',

    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},

        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

            vim.keymap.set('n', '<Leader>e', function()
              local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
              if diagnostics[1] == nil then
                vim.print('not diagnostic found')
                return
              end

              local source = diagnostics[1].source
              if source == 'rustc' or source == 'rust-analyzer' then
                vim.cmd.RustLsp({ 'renderDiagnostic', 'current' })
              else
                vim.diagnostic.open_float()
              end
            end)

            vim.keymap.set('n', '<Leader>r', '<cmd>RustLsp explainError<cr>')
            vim.keymap.set('n', 'K', '<cmd>RustLsp hover actions<cr>')
            -- vim.keymap.set('n', 'J', '<cmd>RustLsp joinLines<cr>')
          end,

          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              checkOnSave = {
                allFeatures = true,
                command = 'clippy',
                extraArgs = { '--no-deps' },
              },
            },
          },
        },

        -- DAP configuration
        dap = {},
      }
    end,
  },

  { -- Rustaceanvim Neotest integration
    'nvim-neotest/neotest',
    opts = function(_, opts) table.insert(opts.adapters, require('rustaceanvim.neotest')) end,
  },

  {
    'mfussenegger/nvim-dap',
    opts = {
      configurations = {
        rust = {
          {
            name = 'Debug Test',
            type = 'codelldb',
            request = 'launch',
            program = function() return cargo_build('cargo build --tests -q --message-format=json') end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            showDisassembly = 'never',
          },
          {
            name = 'Debug Bin',
            type = 'codelldb',
            request = 'launch',
            program = function() return cargo_build('cargo build -q --message-format=json') end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            showDisassembly = 'never',
          },
        },
      },
    },
  },
}
