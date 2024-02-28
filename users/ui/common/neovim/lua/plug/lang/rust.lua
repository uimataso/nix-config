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
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'rust-analyzer', 'codelldb' })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Ensure mason installs the server
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = {
                allFeatures = true,
                command = 'clippy',
                extraArgs = { '--no-deps', '--',
                  '-W', 'clippy::pedantic',
                  '-W', 'clippy::nursery',
                  '-A', 'clippy::must_use_candidate',
                },
              },
            },
          },
        },
      },
    }
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
            program = function()
              return cargo_build('cargo build --tests -q --message-format=json')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            showDisassembly = 'never'
          },
          {
            name = 'Debug Bin',
            type = 'codelldb',
            request = 'launch',
            program = function()
              return cargo_build('cargo build -q --message-format=json')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            showDisassembly = 'never'
          }
        }
      },
    },
  },

  {
    'nvim-neotest/neotest',
    dependencies = {
      'rouge8/neotest-rust', -- $ cargo install cargo-nextest
    },
    opts = function(_, opts)
      table.insert(opts.adapters, require('neotest-rust'))
    end
  },
}
