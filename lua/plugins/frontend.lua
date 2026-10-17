---@type LazySpec
return {
  {
    'pmizio/typescript-tools.nvim',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    config = function()
      require('typescript-tools').setup {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        ---@type Settings
        settings = {
          tsserver_format_options = { tabSize = 4, indentSize = 4 },
        },
      }
    end,
  },
}
