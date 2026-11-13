---@type LazySpec
return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>db', desc = 'Toggle breakpoint' },
      { '<leader>dgb', desc = 'Run to cursor' },
      { '<leader>d?', desc = 'Evaluate expression' },
      { '<leader>dc', desc = 'Continue' },
      { '<leader>dl', desc = 'Step into' },
      { '<leader>dj', desc = 'Step over' },
      { '<leader>dh', desc = 'Step out' },
      { '<leader>du', desc = 'Run to cursor' },
      { '<leader>de', desc = 'Terminate' },
      { '<leader>dr', desc = 'Restart' },
      { '<leader>td', desc = 'Toggle DAP UI' },
      { '<leader>da', desc = 'Toggle all DAP UI windows' },
      { '<leader>dS', desc = 'Toggle DAP scopes' },
      { '<leader>dR', desc = 'Toggle DAP REPL' },
      { '<leader>dC', desc = 'Toggle DAP console' },
      { '<leader>df', desc = 'Float DAP element' },
      { '<leader>ds', desc = 'Toggle debug sessions' },
    },
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
            ft = 'go',
          },
        },
      },
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
      },
      'theHamsta/nvim-dap-virtual-text',
      'mason-org/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      ---@type dapui.Config
      local opts = {
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
              { id = 'repl', size = 1 },
            },
            position = 'bottom',
            size = 10,
          },
          {
            elements = {
              { id = 'console', size = 1 },
            },
            position = 'bottom',
            size = 10,
          },
        },
      }
      ui.setup(opts)
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
      local function toggle_ui()
        ui.toggle { reset = true }
      end
      vim.keymap.set('n', '<leader>td', toggle_ui, { desc = '[T]oggle [D]AP UI' })
      vim.keymap.set('n', '<leader>dA', toggle_ui, { desc = 'Toggle all DAP UI windows' })

      for layout, element in ipairs {
        { key = 'S', name = 'scopes' },
        { key = 'R', name = 'REPL' },
        { key = 'C', name = 'console' },
      } do
        vim.keymap.set('n', '<leader>d' .. element.key, function()
          ui.toggle { layout = layout }
        end, { desc = 'Toggle DAP ' .. element.name })
      end

      vim.keymap.set('n', '<leader>df', function()
        ---@diagnostic disable-next-line: missing-parameter
        ui.float_element()
      end, { desc = '[d]apui [f]loat element' })

      local function open_ui_if_closed()
        for _, layout in ipairs(require('dapui.windows').layouts) do
          if layout:is_open() then
            return
          end
        end
        ui.open()
      end
      dap.listeners.before.attach.dapui_config = open_ui_if_closed
      dap.listeners.before.launch.dapui_config = open_ui_if_closed

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
          -- Focus the sidebar window
          if session_sidebar.win and vim.api.nvim_win_is_valid(session_sidebar.win) then
            vim.api.nvim_set_current_win(session_sidebar.win)
          end
        end
      end, { desc = '[d]ap [s]ession sidebar' })
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = { 'mfussenegger/nvim-dap' },
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
    lazy = true,
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'dap'
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    lazy = true,
    config = function()
      ---@type nvim_dap_virtual_text_options
      local opts = {
        enabled = true,
        virt_text_pos = 'eol',
      }
      require('nvim-dap-virtual-text').setup(opts)
    end,
  },
}
