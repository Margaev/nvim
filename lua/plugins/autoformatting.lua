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
          require('conform').format { async = true, lsp_format = 'fallback' }
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
        sqlfluff = {
          command = 'sqlfluff',
          args = { 'format', '--stdin-filename', '$FILENAME', '-' },
        },
        -- https://github.com/airlift/airstyle (Maven plugin only, no stdin mode).
        -- Conform writes the buffer to a temp file next to the original; we
        -- restrict the plugin to just that file via `airstyle.includes`.
        airstyle = {
          -- Prefer the project's Maven wrapper: project extensions (e.g. takari)
          -- can be incompatible with the globally installed Maven version.
          command = function(_, ctx)
            -- mvnw lives at the top-level project, not in the nearest module.
            local root = vim.fs.root(ctx.dirname, { 'mvnw' })
            return root and (root .. '/mvnw') or 'mvn'
          end,
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
