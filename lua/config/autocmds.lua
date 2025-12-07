vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  pattern = '*.json',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, '\n')

    local tmpfile = os.tmpname()
    local outfile = tmpfile .. '_out'
    local f = io.open(tmpfile, 'w')
    if not f then
      return
    end
    f:write(input)
    f:close()

    local ok = os.execute(string.format('jq . %s > %s 2>/dev/null', tmpfile, outfile))
    if ok == 0 then
      local out = io.open(outfile, 'r')
      if out then
        local formatted = out:read '*a'
        out:close()
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(formatted, '\n'))
      end
    end

    os.remove(tmpfile)
    os.remove(outfile)
  end,
})

-- keymaps specific for python
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.keymap.set(
      'n',
      '<leader>SU',
      [[:s/Union\[\(.*\)\]/\=substitute(submatch(1), ', ', ' | ', 'g')/<CR>]],
      { buffer = true, desc = '[S]ubstitute [U]nion to |' }
    )
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.keymap.set('n', '<leader>SO', [[:s/Optional\[\(.*\)\]/\=submatch(1) . ' | None'/<CR>]], { buffer = true, desc = '[S]ubstitute [O]ptional to | None' })
  end,
})
