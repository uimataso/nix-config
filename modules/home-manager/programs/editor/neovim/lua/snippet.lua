-- From:
-- - <https://github.com/boltlessengineer/NativeVim>
-- - <https://github.com/DimitrisDimitropoulos/yasp.nvim>

---Refer to <https://microsoft.github.io/language-server-protocol/specification/#snippet_syntax>
---for the specification of valid body.
---@param prefix string trigger string for snippet
---@param body string snippet text that will be expanded
---@param opts? vim.keymap.set.Opts
function vim.snippet.add(prefix, body, opts)
  vim.keymap.set('ia', prefix, function()
    -- If abbrev is expanded with keys like "(", ")", "<cr>", "<space>",
    -- don't expand the snippet. Only accept "<c-]>" as trigger key.
    local c = vim.fn.nr2char(vim.fn.getchar(0))
    if c ~= '' then
      vim.api.nvim_feedkeys(prefix .. c, 'i', true)
      return
    end
    vim.snippet.expand(body)
  end, opts)
end

---Read the content of a file as a string.
---the read is done with the permissions rrr (read only)
---@param path string Path to the file
---@return string buffer Contents of file as a string
local function read_file(path)
  -- permissions: rrr
  local fd = assert(vim.uv.fs_open(path, 'r', tonumber('0444', 8)))
  local stat = assert(vim.uv.fs_fstat(fd))
  -- read from offset 0.
  local buf = assert(vim.uv.fs_read(fd, stat.size, 0))
  vim.uv.fs_close(fd)
  return buf
end

---Parse the `package.json` file and return a list of snippet paths
---@param pkg_path string
---@return table file_paths
local function parse_pkg(pkg_path)
  local data = vim.json.decode(read_file(pkg_path))
  local base_path = vim.fn.fnamemodify(pkg_path, ':h')

  local file_paths = {}
  for _, snip in ipairs(data.contributes.snippets) do
    local languages = type(snip.language) == 'table' and snip.language or { snip.language }
    local abs_path = vim.fn.fnamemodify(base_path .. '/' .. snip.path, ':p')
    file_paths[abs_path] = languages
  end
  return file_paths
end

---@param snip_path string
---@return table results
local function parse_snippet(snip_path)
  local data = vim.json.decode(read_file(snip_path))
  local snippets = {}
  for _name, snip in pairs(data) do
    local prefixes = type(snip.prefix) == 'table' and snip.prefix or { snip.prefix }
    local body = type(snip.body) == 'table' and table.concat(snip.body, '\n') or snip.body
    for _, prefix in pairs(prefixes) do
      snippets[prefix] = body
    end
  end
  return snippets
end

local function parse_snippets(pkg_path)
  local snip_paths = parse_pkg(pkg_path)
  local snippets = {}
  for path, langs in pairs(snip_paths) do
    local snips = parse_snippet(path)
    for _, lang in pairs(langs) do
      snippets[lang] = vim.tbl_deep_extend('force', snippets[lang] or {}, snips)
    end
  end
  return snippets
end

local snip_pkg_path = vim.fn.stdpath('config') .. '/snippets/package.json'
local snippets = parse_snippets(snip_pkg_path)

local au = require('utils').au
local ag = require('utils').ag
ag('uima/Snippet', function(g)
  au('FileType', {
    group = g,
    callback = function()
      local ft = vim.bo.filetype
      local snips = vim.tbl_deep_extend('force', snippets[ft] or {}, snippets['all'] or {})
      for prefix, body in pairs(snips) do
        vim.snippet.add(prefix, body, { buffer = 0 })
      end
    end,
  })
end)
