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

-- Server Settings
local servers = {
  bashls = {
    handlers = {
      -- disable diagnostic on `.env` file
      ['textDocument/publishDiagnostics'] = function(err, res, ...)
        local file_name = vim.fn.fnamemodify(vim.uri_to_fname(res.uri), ':t')
        if string.match(file_name, '^%.env') == nil then
          return vim.lsp.diagnostic.on_publish_diagnostics(err, res, ...)
        end
      end,
    },
  },
  clangd = {
    filetypes = {
      'c',
      'cpp',
      'objc',
      'objcpp',
      'cuda',
    },
  },
  nil_ls = {},
  nixd = {},
  vacuum = {},
  ts_ls = {},
  marksman = {},
  -- typos_lsp = {
  --   init_options = {
  --     diagnosticSeverity = 'Hint',
  --   },
  --   on_attach = function(client, _)
  --     local diagnostic_ns = vim.lsp.diagnostic.get_namespace(client.id)
  --     require('utils').overwrite_diagnostic_highlight(
  --       diagnostic_ns,
  --       'uima/TyposLspHighlight',
  --       'SpellBad'
  --     )
  --   end,
  -- },
  -- harper_ls = {
  --   settings = {
  --     ['harper-ls'] = {},
  --   },
  --   on_attach = function(client, _)
  --     local diagnostic_ns = vim.lsp.diagnostic.get_namespace(client.id)
  --     require('utils').overwrite_diagnostic_highlight(
  --       diagnostic_ns,
  --       'uima/HarperLspHighlight',
  --       'SpellBad'
  --     )
  --   end,
  -- },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          disable = { 'missing-fields' },
          globals = { 'vim', 'Snacks' },
        },
      },
    },
  },
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
}

return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,

    dependencies = {
      { 'saghen/blink.cmp' },
    },

    opts = {
      servers = servers,
    },

    config = function(_, opts)
      local capabilities = get_capabilities(opts.capabilities)
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          server_opts = vim.tbl_deep_extend('force', {
            capabilities = vim.deepcopy(capabilities),
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
}
