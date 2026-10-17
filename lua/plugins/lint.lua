---@type LazySpec
return {
  {
    'mfussenegger/nvim-lint',
    ft = { 'sql' },
    config = function()
      local lint = require 'lint'

      -- Configure SQLFluff for SQL files.
      lint.linters_by_ft.sql = { 'sqlfluff' }

      -- Let SQLFluff discover the dialect and rules from .sqlfluff.
      -- Pass the real filename because SQLFluff receives the buffer via stdin.
      lint.linters.sqlfluff.args = {
        'lint',
        '--format=json',
        '--stdin-filename',
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
        '-',
      }

      -- Run linting when opening or saving a named file buffer.
      local group = vim.api.nvim_create_augroup('sqlfluff_lint', {
        clear = true,
      })

      vim.api.nvim_create_autocmd({
        'FileType',
        'BufWritePost',
      }, {
        group = group,
        callback = function()
          if vim.bo.buftype ~= '' or vim.api.nvim_buf_get_name(0) == '' then
            return
          end
          lint.try_lint()
        end,
      })
    end,
  },
}
