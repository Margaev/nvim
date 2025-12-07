return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python',
        },
      }
    end,
    keys = {
      {
        '<leader>o',
        group = '🧪 Test',
        nowait = true,
        remap = false,
      },
      {
        '<leader>or',
        "<cmd>lua require('neotest').run.run()<cr>",
        desc = 'Run nearest test',
      },
      {
        '<leader>of',
        "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
        desc = 'Run current file',
      },
      {
        '<leader>oa',
        "<cmd>lua require('neotest').run.run({ suite = true })<cr>",
        desc = 'Run all tests',
      },
      {
        '<leader>od',
        "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
        desc = 'Debug nearest test',
      },
      {
        '<leader>os',
        "<cmd>lua require('neotest').run.stop()<cr>",
        desc = 'Stop test',
      },
      {
        '<leader>on',
        "<cmd>lua require('neotest').run.attach()<cr>",
        desc = 'Attach to nearest test',
      },
      {
        '<leader>oo',
        "<cmd>lua require('neotest').output.open()<cr>",
        desc = 'Show test output',
      },
      {
        '<leader>op',
        "<cmd>lua require('neotest').output_panel.toggle()<cr>",
        desc = 'Toggle output panel',
      },
      {
        '<leader>ov',
        "<cmd>lua require('neotest').summary.toggle()<cr>",
        desc = 'Toggle summary',
      },
      {
        '<leader>oc',
        "<cmd>lua require('neotest').run.run({ suite = true, env = { CI = true } })<cr>",
        desc = 'Run all tests with CI',
      },
    },
  },
}
