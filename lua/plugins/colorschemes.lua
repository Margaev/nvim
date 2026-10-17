---@type LazySpec
return {
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'xero/miasma.nvim', lazy = true },
  { 'sainnhe/gruvbox-material', lazy = true },
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
