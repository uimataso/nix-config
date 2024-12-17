return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,

    dependencies = {
      {
        'hrsh7th/nvim-cmp',
        dependencies = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-nvim-lsp-signature-help',
        },
        opts = function(_, opts)
          local cmp = require('cmp')
          opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
          }))
        end,
      },
    },

    opts = {
      servers = {
        typos_lsp = {
          init_options = {
            diagnosticSeverity = 'Hint',
          },
          on_attach = function(client, _)
            local diagnostic_ns = vim.lsp.diagnostic.get_namespace(client.id)
            local typos_hl_ns = vim.api.nvim_create_namespace('typos_hl')

            vim.diagnostic.handlers[typos_hl_ns] = {
              show = function(namespace, bufnr, diagnostics, _)
                if namespace ~= diagnostic_ns then
                  return
                end

                for _, diagnostic in ipairs(diagnostics) do
                  vim.api.nvim_buf_add_highlight(
                    bufnr,
                    typos_hl_ns,
                    'SpellBad',
                    diagnostic.lnum,
                    diagnostic.col,
                    diagnostic.end_col
                  )
                end
              end,

              hide = function(namespace, bufnr)
                if namespace == diagnostic_ns then
                  vim.api.nvim_buf_clear_namespace(bufnr, typos_hl_ns, 0, -1)
                end
              end,
            }
          end,
        },
      },

      diagnostics = {
        virtual_text = false,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = 'minimal',
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      },
    },

    config = function(_, opts)
      -- Capabilities
      local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          server_opts = vim.tbl_deep_extend('force', {
            capabilities = vim.deepcopy(capabilities),
          }, server_opts or {})

          require('lspconfig')[server].setup(server_opts)
        end
      end

      -- Icon define
      local function set_sign(name, text)
        vim.fn.sign_define('DiagnosticSign' .. name, { texthl = 'DiagnosticSign' .. name, text = text, numhl = '' })
      end
      set_sign('Error', '')
      set_sign('Warn', '')
      set_sign('Hint', '')
      set_sign('Info', '')

      vim.diagnostic.config(opts.diagnostics)
    end,
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
}
