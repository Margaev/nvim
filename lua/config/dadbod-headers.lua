-- pin header in dbout
local M = {}
local cache = {}
local winbar = "%!v:lua.require'config.dadbod-headers'.render()"

local function headers(buf)
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  if cache[buf] and cache[buf].tick == tick then
    return cache[buf].headers
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local found = {}
  for i = 2, #lines do
    local line, previous = lines[i], lines[i - 1]
    -- PostgreSQL/SQLite use an underline; MySQL encloses its header in borders.
    local separator = line:match '^%s*[-+%s]+$' and line:find('-', 1, true)
    local boxed_header = lines[i - 2] == line and not (lines[i - 3] or ''):match '^%s*|'
    if separator and previous:find '[^%s+|-]' and (not line:match '^%s*%+' or boxed_header) then
      found[#found + 1] = { row = i - 1, text = previous }
    end
  end
  cache[buf] = { tick = tick, headers = found }
  return found
end

local function visible_text(text, left, width, tabstop)
  local parts, column = {}, 0
  -- Keep combining marks with their base character and measure screen cells.
  for _, char in ipairs(vim.fn.split(text, '\\zs')) do
    local size = char == '\t' and (tabstop - column % tabstop) or vim.fn.strdisplaywidth(char)
    local finish = column + size
    if column >= left + width then
      break
    end
    if finish > left then
      if char == '\t' or column < left or finish > left + width then
        parts[#parts + 1] = string.rep(' ', math.min(finish, left + width) - math.max(column, left))
      else
        parts[#parts + 1] = char
      end
    end
    column = finish
  end
  return table.concat(parts)
end

function M.render()
  local win = tonumber(vim.g.statusline_winid) or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local found = headers(buf)
  local header = found[1]
  local row = vim.api.nvim_win_get_cursor(win)[1]
  for _, candidate in ipairs(found) do
    if candidate.row > row then
      break
    end
    header = candidate
  end
  if not header then
    return ''
  end
  local info = vim.fn.getwininfo(win)[1]
  local text = visible_text(header.text, info.leftcol, math.max(0, info.width - info.textoff), vim.bo[buf].tabstop)
  -- The winbar spans the gutter too; column names are literal statusline text.
  return (string.rep(' ', info.textoff) .. text):gsub('%%', '%%%%')
end

local function refresh(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= 'dbout' then
    return
  end
  local enabled = vim.b[buf].dbout_pin_headers ~= false and #headers(buf) > 0
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if vim.api.nvim_win_get_config(win).relative == '' then
      vim.wo[win].winbar = enabled and winbar or ''
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup('dadbod_pinned_headers', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'dbout',
    callback = function(event)
      vim.keymap.set('n', '<leader>Dh', function()
        vim.b[event.buf].dbout_pin_headers = vim.b[event.buf].dbout_pin_headers == false
        refresh(event.buf)
      end, { buffer = event.buf, desc = 'Toggle pinned result headers' })
      refresh(event.buf)
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'BufReadPost' }, {
    group = group,
    callback = function(event)
      refresh(event.buf)
    end,
  })
  vim.api.nvim_create_autocmd('BufUnload', {
    group = group,
    callback = function(event)
      cache[event.buf] = nil
    end,
  })
  vim.api.nvim_create_autocmd('WinScrolled', {
    group = group,
    callback = function()
      for id in pairs(vim.v.event) do
        local win = tonumber(id)
        if win and vim.api.nvim_win_is_valid(win) and vim.wo[win].winbar == winbar then
          vim.cmd 'redrawstatus!'
          break
        end
      end
    end,
  })
end

return M
