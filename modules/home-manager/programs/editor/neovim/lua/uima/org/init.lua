local M = {}

M.org_dir = '/share/notes'

--- Set by the template engine before `:edit` so the auto meta-header
--- autocmd skips the buffer (the template provides its own header).
M.skip_next_header = false

---@param path string
---@return string
function M.org_path(path)
  return ('%s/%s'):format(M.org_dir, path)
end

--- Plain ISO date (YYYY-MM-DD), matching Emacs org `#+date:`.
function M.org_date()
  return os.date('%Y-%m-%d')
end

---@return string
function M.resolve_author()
  local name = vim.fn.system({ 'git', 'config', 'user.name' })
  name = vim.trim(name)
  if name == '' or vim.v.shell_error ~= 0 then
    return vim.env.USER or ''
  end
  return name
end

--- Title-case a filename stem into a human title.
---@param path string
---@return string
function M.title_from_path(path)
  local stem = vim.fs.basename(path):gsub('%.org$', '')
  stem = stem:gsub('[-_]+', ' ')
  return (stem:gsub('%f[%w]%w', function(c)
    return c:upper()
  end))
end

--- Insert an org file metadata header (title/author/date) into an empty org buffer.
function M.insert_meta_header(bufnr, path)
  local lines = {
    '#+title: ' .. M.title_from_path(path),
    '#+author: uima',
    '#+date: ' .. M.org_date(),
    '',
  }
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  if vim.api.nvim_win_get_buf(0) == bufnr then
    vim.api.nvim_win_set_cursor(0, { #lines, 0 })
  end
end

---@return boolean
function M.buf_is_empty(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return #lines == 0 or (#lines == 1 and lines[1] == '')
end

return M
