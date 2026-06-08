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

      ui.setup {
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 1 },
            },
            position = 'left',
            size = 0.2,
          },
          {
            elements = {
              { id = 'repl', size = 0.4 },
              { id = 'console', size = 0.6 },
            },
            position = 'bottom',
            size = 20,
          },
        },
      }
      require('dap-go').setup()
      dap.configurations.go = {
        {
          type = 'go',
          name = 'file',
          request = 'launch',
          program = '${fileDirname}',
          outputMode = 'remote',
        },
      }
      dap.configurations.scala = {
        {
          type = 'scala',
          request = 'launch',
          name = 'Run or Test Target',
          metals = {
            runType = 'runOrTestFile',
          },
        },
      }

      vim.keymap.set('n', '<space>db', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>dgb', dap.run_to_cursor)

      vim.keymap.set('n', '<space>d?', function()
        ---@diagnostic disable-next-line: missing-fields
        ui.eval(nil, { enter = true, desc = 'eval var under cursor' })
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

      vim.keymap.set('n', '<leader>df', function()
        ---@diagnostic disable-next-line: missing-parameter
        ui.float_element()
      end, { desc = '[d]apui [f]loat element' })

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

      local widgets = require 'dap.ui.widgets'
      local session_sidebar = nil

      vim.keymap.set('n', '<leader>ds', function()
        -- Check if the sidebar instance exists and its buffer is still loaded in a window
        if session_sidebar and session_sidebar.buf and vim.fn.bufwinnr(session_sidebar.buf) ~= -1 then
          session_sidebar.close()
          session_sidebar = nil
        else
          session_sidebar = widgets.sidebar(widgets.sessions)
          session_sidebar.open()
        end
      end, { desc = '[d]ap [s]ession sidebar' })
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
