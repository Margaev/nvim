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

return {
  {
    'github/copilot.vim',
    config = function()
      vim.g.copilot_enabled = false
      vim.keymap.set('n', '<leader>ct', toggle_copilot, { desc = 'Toggle copilot' })
    end,
  },
  {
    'robitx/gp.nvim',
    config = function()
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
      local conf = {
        openai_api_key = os.getenv 'EON_GPT_KEY',
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
            name = 'MyCustomAgent',
            provider = 'copilot',
            chat = true,
            command = true,
            model = { model = 'gpt-4-turbo' },
            system_prompt = 'Answer any query with just: Sure thing..',
            disable = true,
          },
        },
      }
      require('gp').setup(conf)

      vim.keymap.set('n', '<leader>gpt', '<CMD>GpChatToggle popup<CR>', { desc = 'GpChat toggle' })
      vim.keymap.set('n', '<leader>gpn', '<CMD>GpChatNew popup<CR>', { desc = 'GpChat implement' })
      vim.keymap.set('v', '<leader>gpi', '<CMD>GpImplement<CR>', { desc = 'implement' })
      vim.keymap.set('n', '<leader>gpf', '<CMD>GpChatFinder<CR>', { desc = 'chat finder' })
      vim.keymap.set('v', '<leader>gpr', '<CMD>GpRewrite<CR>', { desc = 'rewrite' })
      vim.keymap.set('n', '<leader>gps', '<CMD>GpStop<CR>', { desc = 'stop' })
      vim.keymap.set('n', '<leader>gpa', '<CMD>GpSelectAgent<CR>', { desc = 'select agent' })
    end,
  },
}
