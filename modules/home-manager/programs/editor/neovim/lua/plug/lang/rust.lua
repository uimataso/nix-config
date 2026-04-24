vim.api.nvim_create_user_command('CargoFeatures', function(opts)
  local features = opts.fargs

  local quoted = {}
  for _, f in ipairs(features) do
    table.insert(quoted, string.format('"%s"', f))
  end

  local cmd = string.format(
    'RustAnalyzer config { cargo = { features = { %s } } }',
    table.concat(quoted, ', ')
  )

  vim.cmd(cmd)

  vim.print('rust-analyzer features set to: ' .. table.concat(features, ', '))
end, {
  nargs = '*',
})

return {
  {
    'mrcjkb/rustaceanvim',
    version = '^8',
    ft = 'rust',

    config = function()
      vim.g.rustaceanvim = {
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

            vim.keymap.set('n', '<Leader>rt', '<cmd>RustLsp testables<cr>') -- TODO: Neotest
            -- vim.keymap.set('n', '<Leader>rd', '<cmd>RustLsp renderDiagnostic current<cr>')
            vim.keymap.set('n', '<C-w><C-d>', '<cmd>RustLsp renderDiagnostic current<cr>')
            vim.keymap.set('n', '<Leader>re', '<cmd>RustLsp explainError<cr>')
            vim.keymap.set('n', '<Leader>rrd', '<cmd>RustLsp relatedDiagnostics<cr>')
            vim.keymap.set('n', '<Leader>rrt', '<cmd>RustLsp relatedTests<cr>')
            vim.keymap.set('n', '<Leader>rod', '<cmd>RustLsp openDocs<cr>')
            vim.keymap.set('n', '<Leader>roc', '<cmd>RustLsp openCargo<cr>')
          end,

          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              -- TODO: autocomplete with `cargo read-manifest | jq .features`?
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
