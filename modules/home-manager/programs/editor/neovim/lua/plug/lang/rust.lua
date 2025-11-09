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
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

            vim.keymap.set('n', '<Leader>rr', function()
              local diagnostics =
                vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
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
            vim.keymap.set('n', '<Leader>re', '<cmd>RustLsp explainError<cr>')
          end,

          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              cargo = {
                -- TODO: config features in runtime
                -- features = 'all',
              },
              check = {
                command = 'clippy',
                extraArgs = { '--no-deps' },
              },
            },
          },
        },
      }
    end,
  },

  {
    'saecki/crates.nvim',
    tag = 'stable',
    event = { 'BufRead Cargo.toml' },
    cmd = { 'Crates' },

    opts = {},

    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)

      vim.keymap.set('n', '<leader>ct', crates.toggle)
      vim.keymap.set('n', '<leader>cr', crates.reload)

      vim.keymap.set('n', '<leader>cv', crates.show_versions_popup)
      vim.keymap.set('n', '<leader>cf', crates.show_features_popup)
      vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup)

      vim.keymap.set('n', '<leader>cu', crates.update_crate)
      vim.keymap.set('v', '<leader>cu', crates.update_crates)
      vim.keymap.set('n', '<leader>ca', crates.update_all_crates)
      vim.keymap.set('n', '<leader>cU', crates.upgrade_crate)
      vim.keymap.set('v', '<leader>cU', crates.upgrade_crates)
      vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates)

      vim.keymap.set('n', '<leader>cx', crates.expand_plain_crate_to_inline_table)
      vim.keymap.set('n', '<leader>cX', crates.extract_crate_into_table)

      vim.keymap.set('n', '<leader>cH', crates.open_homepage)
      vim.keymap.set('n', '<leader>cR', crates.open_repository)
      vim.keymap.set('n', '<leader>cD', crates.open_documentation)
      vim.keymap.set('n', '<leader>cC', crates.open_crates_io)
      vim.keymap.set('n', '<leader>cL', crates.open_lib_rs)
    end,
  },
}
