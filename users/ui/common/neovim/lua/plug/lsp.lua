return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-nvim-lsp-signature-help',
        },
        opts = function(_, opts)
          local cmp = require("cmp")
          opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
          }))
        end,
      },
    },

    opts = {
      diagnostics = {
        virtual_text = false,
        update_in_insert = true,
        underline = false,
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

      local servers = opts.servers
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = vim.tbl_deep_extend('force', {
            capabilities = vim.deepcopy(capabilities),
          }, server_opts or {})

          require("lspconfig")[server].setup(server_opts)
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

      vim.lsp.handlers['textDocument/hover']         = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded', })
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
        { border = 'rounded', })
    end
  },

  { -- notification for lsp
    'j-hui/fidget.nvim',
    event = 'BufReadPre',
    opts = {
      notification = {
        window = {
          winblend = 0,
        }
      }
    },
  },
}
