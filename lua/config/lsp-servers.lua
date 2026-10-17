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
}
