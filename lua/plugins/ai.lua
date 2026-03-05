local function toggle_copilot()
  if vim.b.copilot_enabled == nil then
    vim.b.copilot_enabled = true
  end
  vim.b.copilot_enabled = not vim.b.copilot_enabled
  if vim.b.copilot_enabled then
    vim.notify('Copilot enabled', vim.log.levels.INFO)
  else
    vim.notify('Copilot disabled', vim.log.levels.INFO)
  end
end
local system_prompt = 'You are a senior programmer AI assistant.\n\n'
  .. "I'm Andrei, you can call me android or comrade:\n\n"
  .. 'The user provided the additional info about how they would like you to respond:\n\n'
  .. "- If you're unsure don't guess and say you don't know instead.\n"
  .. '- Ask question if you need clarification to provide better answer.\n'
  .. "- Don't elide any code from your output if the answer requires coding.\n"
  .. '- Answer short and to the point. The user will ask for elaboration if needed.\n'
  .. "- If the user asks for code; return code only; don't explain how the code works unless asked.\n"
  .. "- If the user question is fundamentally incorrect, don't provide an inconsistent answer, briefly explain why the user question is incorrect.\n"
  .. "- If you explained the user is incorrect, but he says the word 'override', reply the next answer with: 'override acknowledged', assume the user is correct; re-evaluate the question and provide a new answer taking it as a fact that the user is correct.\n"
  .. '- When generating python, generate the code that complies with ruff and basedpyright with `typeCheckingMode = "standard"` setting'
  .. '- If the user provides the filenames for the code, mention which file you are generating the code for'

return {
  {
    'github/copilot.vim',
    config = function()
      vim.g.copilot_enabled = false
      vim.keymap.set('n', '<leader>tC', toggle_copilot, { desc = '[t]oggle [C]opilot' })
    end,
  },
  {
    'robitx/gp.nvim',
    config = function()
      local conf = {
        openai_api_key = os.getenv 'OPENAI_API_KEY',
        providers = {
          openai = {
            -- secret = os.getenv 'EON_GPT_KEY',
            -- deployments = models, available:
            -- 'gpt-5',
            -- 'gpt-35-turbo',
            -- 'gpt35-turbo-instruct',
            -- 'gpt-4o',
            -- 'gpt-4-turbo',
            -- 'gpt-4o-mini',
            -- 'gpt-4.1',
            -- 'gemini-2.0-flash-001',
            -- 'llama-3.3-70b-instruct-maas'
            endpoint = 'https://genai-api.eon.com/llmgw/central/openai/deployments/gpt-4.1/chat/completions?api-version=2024-03-01-preview',
          },
          copilot = {
            endpoint = 'https://api.githubcopilot.com/chat/completions',
            secret = {
              'bash',
              '-c',
              "cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
          },
        },
        agents = {
          {
            name = 'ChatGPT4-1',
            disable = false,
            chat = true,
            command = true,
            model = { model = 'gpt-4.1', temperature = 0.7, top_p = 0.5 },
            system_prompt = system_prompt,
          },
          {
            name = 'ChatGPT5',
            disable = false,
            chat = true,
            command = true,
            model = { model = 'gpt-5', temperature = 0.7, top_p = 0.5 },
            system_prompt = system_prompt,
          },
          {
            name = 'Copilot',
            provider = 'copilot',
            chat = true,
            command = true,
            model = { model = 'gpt-5.2' },
            system_prompt = system_prompt,
          },
        },
      }
      require('gp').setup(conf)

      local chat_view = 'vsplit'

      vim.keymap.set('n', '<leader>gpt', '<CMD>GpChatToggle ' .. chat_view .. '<CR>', { desc = 'GpChat toggle' })
      vim.keymap.set('n', '<leader>gpn', '<CMD>GpChatNew ' .. chat_view .. '<CR>', { desc = 'GpChat implement' })
      vim.keymap.set('n', '<leader>gpf', '<CMD>GpChatFinder<CR>', { desc = 'chat finder' })
      vim.keymap.set('n', '<leader>gps', '<CMD>GpStop<CR>', { desc = 'stop' })
      vim.keymap.set('n', '<leader>gpa', '<CMD>GpSelectAgent<CR>', { desc = 'select agent' })

      vim.keymap.set('v', '<leader>gpp', ":'<,'>GpChatPaste " .. chat_view .. '<CR>', { desc = 'paste selection into chat' })
      vim.keymap.set('n', '<leader>gpr', ':%GpRewrite<CR>', { desc = 'rewrite whole file' })
      vim.keymap.set('v', '<leader>gpr', ":'<,'>GpRewrite<CR>", { desc = 'rewrite' })
      vim.keymap.set('v', '<leader>gpi', ":'<,'>GpImplement<CR>", { desc = 'implement' })
    end,
  },

  -- {
  --   'yetone/avante.nvim',
  --   build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  --   event = 'VeryLazy',
  --   version = false, -- Never set this value to "*"! Never!
  --   ---@module 'avante'
  --   ---@type avante.Config
  --   opts = {
  --     instructions_file = 'avante.md',
  --     provider = 'copilot',
  --     system_prompt = system_prompt,
  --     providers = {
  --       copilot = {
  --         endpoint = 'https://api.githubcopilot.com',
  --         model = 'gpt-5.2',
  --         proxy = nil, -- [protocol://]host[:port] Use this proxy
  --         allow_insecure = false, -- Allow insecure server connections
  --         timeout = 30000, -- Timeout in milliseconds
  --         temperature = 0,
  --         extra_request_body = {
  --           max_tokens = 20480,
  --         },
  --       },
  --     },
  --     mappings = {
  --       submit = {
  --         normal = '<CR>',
  --         insert = '<C-g><C-g>',
  --       },
  --     },
  --     selection = {
  --       enabled = false,
  --       hint_display = 'delayed',
  --     },
  --   },
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --     --- The below dependencies are optional,
  --     'nvim-mini/mini.pick', -- for file_selector provider mini.pick
  --     'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
  --     'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
  --     'ibhagwan/fzf-lua', -- for file_selector provider fzf
  --     'stevearc/dressing.nvim', -- for input provider dressing
  --     'folke/snacks.nvim', -- for input provider snacks
  --     'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
  --     'zbirenbaum/copilot.lua', -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       'HakonHarnes/img-clip.nvim',
  --       event = 'VeryLazy',
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { 'Avante' },
  --       },
  --       ft = { 'Avante' },
  --     },
  --   },
  -- },
}
