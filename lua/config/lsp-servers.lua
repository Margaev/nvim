return {
  gopls = {},
  basedpyright = {
    exclude = {
      '**/__pycache__',
      '**/.git/**',
      '**/.venv/**',
    },
  },
  ts_ls = {},
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
}
