---@type LazySpec
return {
  {
    'rebelot/kanagawa.nvim',
    -- priority = 1000,
    lazy = true,
    -- config = function()
    --   vim.cmd.colorscheme 'kanagawa'
    -- end,
  },
  { 'xero/miasma.nvim', lazy = true },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    ---@module 'tokyonight'
    ---@type tokyonight.Config
    opts = {
      styles = {
        comments = { italic = false },
      },
    },
  },
  { 'rose-pine/neovim', name = 'rose-pine', lazy = true },
}
