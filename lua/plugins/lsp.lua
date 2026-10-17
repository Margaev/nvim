---@type LazySpec
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    ---@module 'lazydev'
    ---@type lazydev.Config
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        ---@module 'mason'
        ---@type MasonSettings
        opts = {},
      },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      {
        'j-hui/fidget.nvim',
        ---@module 'fidget'
        opts = {},
      },

      'saghen/blink.cmp',
    },
    config = function()
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = true })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event)
          -- LspDetach fires before removal, so exclude the departing client.
          for _, client in ipairs(vim.lsp.get_clients { bufnr = event.buf }) do
            if client.id ~= event.data.client_id and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
              return
            end
          end
          vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = event.buf }
          vim.api.nvim_buf_call(event.buf, vim.lsp.buf.clear_references)
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          -- map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- highlight symbols under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = event.buf }
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = require 'config.lsp-servers'

      for name, server in pairs(servers) do
        server = vim.deepcopy(server)
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
      end

      ---@type MasonLspconfigSettings
      local mason_opts = {
        ensure_installed = {}, -- Installed by mason-tool-installer.
        automatic_enable = vim.tbl_keys(servers),
      }
      require('mason-lspconfig').setup(mason_opts)
    end,
  },

  {
    'rachartier/tiny-code-action.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },

      { 'nvim-telescope/telescope.nvim' },
      {
        'folke/snacks.nvim',
        ---@module 'snacks'
        ---@type snacks.Config
        opts = {
          terminal = {},
        },
      },
    },
    event = 'LspAttach',
    opts = {},
    keys = {
      {
        -- '<leader>ca',
        'gra',
        mode = { 'n' },
        function()
          ---@diagnostic disable-next-line: missing-parameter
          require('tiny-code-action').code_action()
        end,
        noremap = true,
        silent = true,
        desc = '[c]ode [a]ction',
      },
    },
  },

  {
    'scalameta/nvim-metals',
    ft = { 'scala', 'sbt' },
    opts = function()
      local metals_config = require('metals').bare_config()
      metals_config.on_attach = function(client, bufnr)
        -- your on_attach function
        require('metals').setup_dap()
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = self.ft,
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },

  { 'mfussenegger/nvim-jdtls' },
}
