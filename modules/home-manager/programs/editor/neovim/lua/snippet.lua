-- From:
-- - <https://github.com/boltlessengineer/NativeVim>
-- - <https://github.com/DimitrisDimitropoulos/yasp.nvim>

-- TODO:
-- - parse package once at beginning
-- - cleanup the code that i don't need

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
function read_file(path)
  -- permissions: rrr
  local fd = assert(vim.uv.fs_open(path, 'r', tonumber('0444', 8)))
  local stat = assert(vim.uv.fs_fstat(fd))
  -- read from offset 0.
  local buf = assert(vim.uv.fs_read(fd, stat.size, 0))
  vim.uv.fs_close(fd)
  return buf
end

---Parse the pkg.json file and return a list of snippet paths
---@param pkg_path string Path to the package.json file
---@param lang string The language to filter the snippets by
---@return string[] file_paths List of absolute paths to the snippet files
local function parse_pkg(pkg_path, lang)
  local pkg = read_file(pkg_path)
  local data = vim.json.decode(pkg)
  local base_path = vim.fn.fnamemodify(pkg_path, ':h')
  local file_paths = {}
  for _, snippet in ipairs(data.contributes.snippets) do
    local languages = snippet.language
    -- Check if it's a list of languages or a single language
    if type(languages) == 'string' then
      languages = { languages }
    end
    -- If a language is provided, check for a match
    if not lang or vim.tbl_contains(languages, lang) then
      -- Prepend the base path to the relative snippet path
      local abs_path = vim.fn.fnamemodify(base_path .. '/' .. snippet.path, ':p')
      table.insert(file_paths, abs_path)
    end
  end
  return file_paths
end

---Process only one JSON encoded string
---@param snips string JSON encoded string containing snippets
---@param desc string Description for the snippets (optional)
---@return table completion_results A table containing completion results formatted for LSP
local function process_snippets(snips, desc)
  local snippets_table = {}
  local snippet_descs = {}
  local completion_results = {
    isIncomplete = false,
    items = {},
  }
  -- Decode the JSON input
  for _, v in pairs(vim.json.decode(snips)) do
    local prefixes = type(v.prefix) == 'table' and v.prefix or { v.prefix }
    -- Handle v.body as a table or string
    local body
    if type(v.body) == 'table' then
      -- Concatenate the table elements into a single string, separated by newlines
      body = table.concat(v.body, '\n')
    else
      -- If it's already a string, use it directly
      body = v.body
    end
    -- Add each prefix-body pair to the table
    for _, prefix in ipairs(prefixes) do
      snippets_table[prefix] = body
      snippet_descs[prefix] = v.description or '-'
    end
  end
  -- Transform the snippets_table into completion_results
  for label, insertText in pairs(snippets_table) do
    local long_desc = vim.fn.has 'nvim-0.11' ~= 1
    table.insert(completion_results.items, {
      detail = tostring(desc) .. (long_desc and ('|' .. tostring(snippet_descs[label])) or ''),
      label = label,
      kind = vim.lsp.protocol.CompletionItemKind['Snippet'],
      documentation = {
        value = insertText,
        kind = vim.lsp.protocol.MarkupKind.Markdown,
      },
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
      insertText = insertText,
      -- fix for blink.cmp
      sortText = tostring(1.02), -- Ensure a low score by setting a high sortText value, not sure
    })
  end
  return completion_results
end

local snip_pkg = vim.fn.stdpath('config') .. '/snippets/package.json'

local au = require('utils').au
local ag = require('utils').ag
ag('uima/Snippet', function(g)
  au('FileType', {
    group = g,
    callback = function()
      local ft = vim.bo.filetype
      local snip_files =
        require('utils').list_merge(parse_pkg(snip_pkg, ft), parse_pkg(snip_pkg, 'all'))

      for _, file in pairs(snip_files) do
        local snips = process_snippets(read_file(file), '')
        for _, snip in pairs(snips.items) do
          vim.snippet.add(snip.label, snip.insertText, { buffer = 0 })
        end
      end
    end,
  })
end)
