return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      -- tree-sitter-cli is required for this to work
      require('nvim-treesitter')
        .install({
          'bash',
          'c',
          'diff',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
          'hcl',
          'terraform',
          'python',
          'go',
        })
        :wait(300000)
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      local ts_select = require 'nvim-treesitter-textobjects.select'

      require('nvim-treesitter-textobjects').setup {
        select = {
          enable = true,
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = 'V', -- linewise instead of <c-v>
          },
          include_surrounding_whitespace = true,
        },
      }

      -- define keymaps manually
      local modes = { 'x', 'o' }
      vim.keymap.set(modes, 'af', function()
        ts_select.select_textobject('@function.outer', 'textobjects')
      end)
      vim.keymap.set(modes, 'if', function()
        ts_select.select_textobject('@function.inner', 'textobjects')
      end)
      vim.keymap.set(modes, 'ac', function()
        ts_select.select_textobject('@class.outer', 'textobjects')
      end)
      vim.keymap.set(modes, 'ic', function()
        ts_select.select_textobject('@class.inner', 'textobjects')
      end)
      vim.keymap.set(modes, 'as', function()
        ts_select.select_textobject('@local.scope', 'locals')
      end)
    end,
  },

  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup {
        use_default_keymaps = false,
      }
      vim.keymap.set('n', '<leader>tj', '<Cmd>TSJToggle<CR>')
    end,
  },
}
