return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
  { 'xero/miasma.nvim', lazy = true },
  { 'sainnhe/gruvbox-material', lazy = true },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    opts = {
      styles = {
        comments = { italic = false },
      },
    },
  },
  { 'rose-pine/neovim', name = 'rose-pine', lazy = true },
}
