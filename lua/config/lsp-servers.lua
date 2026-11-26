return {
  gopls = {},
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          exclude = { '**/__pycache__', '**/.git/**', '**/.venv/**' },
        },
      },
    },
  },
  tailwindcss = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  jsonls = {},
  yamlls = {},
  tofu_ls = {},
  ruff = {},
  lemminx = {},
  jsonnet_ls = {
    -- jsonnet-language-server panics on non-file URIs (e.g. diffview://), so skip those buffers.
    root_dir = function(bufnr, on_dir)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == '' or name:match '^%a[%w+.-]*://' then
        return
      end
      on_dir(vim.fs.root(bufnr, { 'jsonnetfile.json', '.git' }) or vim.fs.dirname(name))
    end,
  },
}
