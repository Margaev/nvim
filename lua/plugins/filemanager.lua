-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  ---@type LazySpec
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    dependencies = {
      'folke/snacks.nvim',
    },
    keys = {
      {
        '<leader>-',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
        '<leader>cw',
        '<cmd>Yazi cwd<cr>',
        desc = "Open the file manager in nvim's working directory",
      },
      {
        '<c-up>',
        '<cmd>Yazi toggle<cr>',
        desc = 'Resume the last yazi session',
      },
    },
    ---@type YaziConfig | {}
    opts = {
      open_for_directories = false,
      show_hidden = true,
      keymaps = {
        show_help = '<c-h>',
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    config = function()
      require('neo-tree').setup {
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
          },
        },
      }
    end,
    keys = {
      {
        '<leader>tt',
        mode = { 'n' },
        '<cmd>Neotree toggle<cr>',
        desc = '[t]oggle neo[t]ree',
      },
    },
  },
}
