local get_capabilities = function(override)
  local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  local has_blink, blink = pcall(require, 'blink.cmp')

  local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    has_blink and blink.get_lsp_capabilities() or {},
    override or {}
  )

  return capabilities
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('uima/LspKeymap', { clear = true }),
  callback = function(args)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition()' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'vim.lsp.buf.declaration()' })
    vim.keymap.set('n', '<leader>dr', vim.diagnostic.reset, { desc = 'vim.diagnostic.reset()' })
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = require('config').border,
    source = true,
    header = '',
    prefix = '',
  },
  signs = {
    text = require('config').signs.diagnostic,
  },
})

return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,

    dependencies = {
      { 'saghen/blink.cmp' },
    },

    opts = {
      servers = {
        typos_lsp = {
          init_options = {
            diagnosticSeverity = 'Hint',
          },
          on_attach = function(client, _)
            local diagnostic_ns = vim.lsp.diagnostic.get_namespace(client.id)
            local typos_hl_ns = vim.api.nvim_create_namespace('uima/TyposLspHighlight')
            require('utils').overwrite_diagnostic_highlight(diagnostic_ns, typos_hl_ns, 'SpellBad')
          end,
        },
        bashls = {},
        clangd = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' },
              },
            },
          },
        },
        nil_ls = {},
        nixd = {},
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                flake8 = { enabled = true },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
              },
            },
          },
        },
        yamlls = {
          filetypes = {
            'yaml',
            'yaml.docker-compose',
            'yaml.gitlab',
            'yaml.openapi',
            'json.openapi',
          },
        },
        vacuum = {},
        ts_ls = {},
      },
    },

    config = function(_, opts)
      local capabilities = get_capabilities(opts.capabilities)

      local handlers = {
        ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
        ['textDocument/signatureHelp'] = vim.lsp.with(
          vim.lsp.handlers.signature_help,
          { border = 'rounded' }
        ),
      }

      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          server_opts = vim.tbl_deep_extend('force', {
            capabilities = vim.deepcopy(capabilities),
            handlers = handlers,
          }, server_opts or {})

          require('lspconfig')[server].setup(server_opts)
        end
      end
    end,
  },

  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  { -- notification for lsp
    'j-hui/fidget.nvim',
    event = 'BufReadPre',

    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  {
    'smjonas/inc-rename.nvim',
    keys = {
      {
        'grn',
        mode = { 'n' },
        function()
          return ':IncRename ' .. vim.fn.expand('<cword>')
        end,
        expr = true,
      },
    },
    opts = {},
  },

  -- {
  --   'rachartier/tiny-inline-diagnostic.nvim',
  --   event = 'VeryLazy', -- Or `LspAttach`
  --   priority = 1000, -- needs to be loaded in first
  --   opts = {
  --     options = {
  --       multiple_diag_under_cursor = true,
  --       -- show_all_diags_on_cursorline = true,
  --     },
  --     signs = {
  --       left = '',
  --       right = '',
  --       diag = '●',
  --       -- arrow = '       ',
  --       arrow = '',
  --       up_arrow = '    ',
  --       vertical = ' │',
  --       vertical_end = ' └',
  --     },
  --     blend = {
  --       factor = 0.22,
  --     },
  --   },
  -- },
}
