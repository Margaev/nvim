return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    lazy = false,
    init = function()
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    -- priority = 1000,
    init = function()
      -- vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    -- priority = 1000
    init = function()
      -- vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    -- priority = 1000,
    config = function()
      -- vim.cmd 'colorscheme rose-pine'
    end,
  },
}
