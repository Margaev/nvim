return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },

  keys = {
    {
      '<leader>Q',
      'vap:DB<CR>',
      mode = 'n',
      desc = 'DBUI_ExecuteSelectedQuery)',
    },
    {
      '<leader>tD',
      '<cmd>DBUIToggle<cr>',
      mode = 'n',
      desc = 'Execute selected SQL',
    },
  },

  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_execute_on_save = 0
  end,
}
