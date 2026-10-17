---@type LazySpec
return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    ---@module 'mason-tool-installer'
    ---@return MasonToolInstallerSettings
    opts = function()
      local servers = require 'config.lsp-servers'

      local ensure_installed = vim.tbl_keys(servers)

      vim.list_extend(ensure_installed, {
        'stylua',
        'delve',
        'java-debug-adapter',
        'debugpy',
        'sqlfluff',
      })

      return {
        ensure_installed = ensure_installed,
      }
    end,
  },
}
