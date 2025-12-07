return {
  {
    'rest-nvim/rest.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'http')
      end,
    },
    keys = {
      {
        '<leader>rr',
        '<Cmd>Rest run<CR>',
        desc = '[R]est [r]un',
      },
      {
        '<leader>rc',
        '<Cmd>Rest cookies<CR>',
        desc = '[R]est [c]ookies',
      },
    },
  },
}
