local maven_launcher = vim.fn.stdpath 'config' .. '/scripts/maven-formatter'

local function is_pom(bufnr)
  return vim.fs.basename(vim.api.nvim_buf_get_name(bufnr)) == 'pom.xml'
end

---@type LazySpec
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          local use_maven = vim.bo.filetype == 'java' or is_pom(0)
          require('conform').format { async = true, lsp_format = use_maven and 'never' or 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        if is_pom(bufnr) then
          return { timeout_ms = 10000, lsp_format = 'never' }
        end
        if vim.bo[bufnr].filetype == 'java' then
          if vim.fs.root(bufnr, 'pom.xml') then
            return { timeout_ms = 10000, lsp_format = 'never' }
          end
          return
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 5000,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters = {
        sortpom = {
          command = maven_launcher,
          stdin = false,
          cwd = function(_, ctx)
            return ctx.dirname
          end,
          args = function(_, ctx)
            return {
              '-q',
              '-B',
              '-N',
              '-f',
              ctx.filename,
              'com.github.ekryd.sortpom:sortpom-maven-plugin:sort',
              '-Dsort.createBackupFile=false',
            }
          end,
        },
        sqlfluff = {
          command = 'sqlfluff',
          args = { 'format', '--stdin-filename', '$FILENAME', '-' },
        },
        -- https://github.com/airlift/airstyle (Maven plugin only, no stdin mode).
        -- Conform writes the buffer to a temp file next to the original; we
        -- restrict the plugin to just that file via `airstyle.includes`.
        airstyle = {
          command = maven_launcher,
          stdin = false,
          tmpfile_format = '.conform.$RANDOM.$FILENAME',
          cwd = function(self, ctx)
            return require('conform.util').root_file { 'pom.xml' }(self, ctx)
          end,
          require_cwd = true,
          args = function(_, ctx)
            return {
              '-q',
              '-B',
              'io.airlift:airstyle-maven-plugin:RELEASE:format',
              '-Dairstyle.includes=**/' .. vim.fs.basename(ctx.filename),
            }
          end,
        },
      },
      formatters_by_ft = {
        xml = function(bufnr)
          return is_pom(bufnr) and { 'sortpom' } or {}
        end,
        java = { 'airstyle' },
        lua = { 'stylua' },
        python = {
          -- 'ruff_fix',
          'ruff_organize_imports',
          'ruff_format',
        },
        sql = { 'sqlfluff' },
      },
    },
  },
  {
    'NMAC427/guess-indent.nvim',
    config = function()
      ---@type GuessIndentConfig
      local opts = {}
      require('guess-indent').setup(opts)
    end,
  },
}
