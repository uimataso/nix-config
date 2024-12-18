-- overwrite the diagnostic highgroup with custom one
local overwrite_diagnostic_highlight = function(diagnostic_ns, highlight_ns, highlight_group)
  vim.diagnostic.handlers[highlight_ns] = {
    show = function(namespace, bufnr, diagnostics, _)
      if namespace == diagnostic_ns then
        for _, diagnostic in ipairs(diagnostics) do
          vim.api.nvim_buf_add_highlight(
            bufnr,
            highlight_ns,
            highlight_group,
            diagnostic.lnum,
            diagnostic.col,
            diagnostic.end_col
          )
        end
      end
    end,

    hide = function(namespace, bufnr)
      if namespace == diagnostic_ns then
        vim.api.nvim_buf_clear_namespace(bufnr, highlight_ns, 0, -1)
      end
    end,
  }
end

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
            overwrite_diagnostic_highlight(diagnostic_ns, typos_hl_ns, 'SpellBad')
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
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
          },
        },
      },
    },

    config = function(_, opts)
      -- Capabilities
      local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      local has_blink, blink = pcall(require, 'blink.cmp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
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
