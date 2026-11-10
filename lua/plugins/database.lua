local function execute_query(scope)
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local view = vim.fn.winsaveview()
  local selection
  if scope == 'selection' then
    selection = { mode = vim.fn.mode(), anchor = vim.fn.getpos 'v', cursor = vim.fn.getpos '.' }
    vim.cmd.normal { args = { vim.keycode '<Esc>' }, bang = true }
  end

  local ok, err = true, nil
  if not vim.b[buf].dbui_db_key_name then
    ok, err = pcall(vim.cmd.DBUIFindBuffer)
  end
  if vim.api.nvim_win_is_valid(win) and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_set_current_win(win)
    vim.fn.winrestview(view)
    if selection then
      vim.fn.setpos('.', selection.anchor)
      vim.cmd.normal { args = { selection.mode }, bang = true }
      vim.fn.setpos('.', selection.cursor)
    end
  else
    return
  end
  local assigned = vim.b[buf].dbui_db_key_name and vim.b[buf].db and vim.b[buf].db ~= ''
  if not assigned then
    -- A failed connection must be selectable again on the next send.
    vim.b[buf].dbui_db_key_name = nil
  end
  if not ok then
    vim.notify(tostring(err), vim.log.levels.ERROR, { title = 'Dadbod' })
    return
  end
  if not assigned then
    return
  end
  if scope == 'paragraph' then
    vim.cmd.normal { args = { 'vip' }, bang = true }
  end
  vim.api.nvim_feedkeys(vim.keycode '<Plug>(DBUI_ExecuteQuery)', 'm', false)
end

---@type LazySpec
return {
  {
    'tpope/vim-dadbod',
    cmd = { 'DB' },
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'tpope/vim-dadbod' },
    ft = { 'sql', 'mysql', 'plsql' },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    keys = {
      { '<leader>Du', '<cmd>DBUIToggle<CR>', desc = 'Toggle database UI' },
      { '<leader>Da', '<cmd>DBUIAddConnection<CR>', desc = 'Add database connection' },
      { '<leader>Dc', '<cmd>DBUIFindBuffer<CR>', desc = 'Assign SQL buffer to database' },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_disable_mappings_sql = 1
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('dadbod_query_mappings', { clear = true }),
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function(event)
          vim.keymap.set('n', '<leader>Ds', function()
            execute_query 'paragraph'
          end, {
            buffer = event.buf,
            desc = 'Execute SQL paragraph',
          })
          vim.keymap.set('x', '<leader>Ds', function()
            execute_query 'selection'
          end, {
            buffer = event.buf,
            desc = 'Execute SQL selection',
          })
          vim.keymap.set('n', '<leader>Df', function()
            execute_query 'file'
          end, {
            buffer = event.buf,
            desc = 'Execute SQL file',
          })
          vim.keymap.set('n', '<leader>Dw', '<Plug>(DBUI_SaveQuery)', {
            buffer = event.buf,
            remap = true,
            desc = 'Save SQL query',
          })
          vim.keymap.set('n', '<leader>De', '<Plug>(DBUI_EditBindParameters)', {
            buffer = event.buf,
            remap = true,
            desc = 'Edit SQL bind parameters',
          })
        end,
      })
    end,
  },
}
