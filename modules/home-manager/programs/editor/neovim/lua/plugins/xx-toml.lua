vim.pack.add({
  'https://github.com/saecki/crates.nvim',
})

local ag = require('uima').ag

ag('uima/RustCargoPlugins', function(au)
  au({ 'BufRead' }, {
    pattern = { 'Cargo.toml' },
    once = true,
    callback = function()
      require('crates').setup({})
    end,
  })

  au({ 'BufRead' }, {
    pattern = { 'Cargo.toml' },
    callback = function(event)
      function set(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = event.buf })
      end

      local crates = require('crates')
      set('n', '<leader>ct', crates.toggle)
      set('n', '<leader>cr', crates.reload)

      set('n', '<leader>cv', crates.show_versions_popup)
      set('n', '<leader>cf', crates.show_features_popup)
      set('n', '<leader>cd', crates.show_dependencies_popup)

      set('n', '<leader>cu', crates.update_crate)
      set('v', '<leader>cu', crates.update_crates)
      set('n', '<leader>ca', crates.update_all_crates)
      set('n', '<leader>cU', crates.upgrade_crate)
      set('v', '<leader>cU', crates.upgrade_crates)
      set('n', '<leader>cA', crates.upgrade_all_crates)

      set('n', '<leader>cx', crates.expand_plain_crate_to_inline_table)
      set('n', '<leader>cX', crates.extract_crate_into_table)

      set('n', '<leader>cH', crates.open_homepage)
      set('n', '<leader>cR', crates.open_repository)
      set('n', '<leader>cD', crates.open_documentation)
      set('n', '<leader>cC', crates.open_crates_io)
      set('n', '<leader>cL', crates.open_lib_rs)
    end,
  })
end)
