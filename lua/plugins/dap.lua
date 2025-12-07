return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'leoluz/nvim-dap-go',
        keys = {
          {
            '<leader>dt',
            function()
              require('dap-go').debug_test()
            end,
            desc = '[D]ebug Go [T]est',
          },
        },
      },
      {
        'rcarriga/nvim-dap-ui',
      },
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dapui').setup()
      require('dap-go').setup()

      vim.keymap.set('n', '<space>db', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>dgb', dap.run_to_cursor)

      vim.keymap.set('n', '<space>d?', function()
        ---@diagnostic disable-next-line: missing-fields
        require('dapui').eval(nil, { enter = true, desc = 'eval var under cursor' })
      end)

      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'continue' })
      vim.keymap.set('n', '<leader>dl', dap.step_into, { desc = 'step into' })
      vim.keymap.set('n', '<leader>dj', dap.step_over, { desc = 'step over' })
      vim.keymap.set('n', '<leader>dh', dap.step_out, { desc = 'step out' })
      vim.keymap.set('n', '<leader>du', dap.run_to_cursor, { desc = 'run to cursor' })
      -- vim.keymap.set('n', '<leader>dsb', dap.step_back, { desc = 'step back' })
      vim.keymap.set('n', '<leader>de', dap.terminate, { desc = 'terminate' })
      vim.keymap.set('n', '<leader>dr', dap.restart, { desc = 'restart' })
      vim.keymap.set('n', '<leader>td', function()
        ui.toggle { reset = true }
      end, { desc = '[T]oggle [D]AP UI' })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   ui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   ui.close()
      -- end
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    build = false,
    config = function()
      local dap_python = require 'dap-python'
      dap_python.setup 'uv'
    end,
    keys = {
      {
        '<leader>dt',
        function()
          require('dap-python').test_method()
        end,
        desc = '[D]ebug Python [T]est',
        ft = 'python',
      },
    },
  },
  {
    'nvim-telescope/telescope-dap.nvim',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'dap'
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup {
        enabled = true,
        virt_text_pos = 'eol',
      }
    end,
  },
}
