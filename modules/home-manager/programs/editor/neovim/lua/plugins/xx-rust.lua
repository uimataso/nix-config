vim.pack.add({
  'https://github.com/mrcjkb/rustaceanvim',
})

local ag = require('uima').ag

ag('uima/RustPlugins', function(au)
  au({ 'FileType' }, {
    pattern = { 'rust' },
    once = true,
    callback = function(event)
      vim.pack.add({
        'https://github.com/mrcjkb/rustaceanvim',
      }, { load = true })

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

      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

            vim.keymap.set('n', '<Leader>tr', '<cmd>RustLsp testables<cr>')

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
  })
end)
