local function try_find(start_path, names)
  return vim.fs.find(names, {
    upward = true,
    path = start_path,
  })[1]
end

local function find_project_root()
  local workspaces = vim.lsp.buf.list_workspace_folders()
  if workspaces and #workspaces > 0 then
    return workspaces[1]
  end

  local buf_path = vim.api.nvim_buf_get_name(0):gsub('oil://', '')
  if buf_path == '' then
    return nil
  end

  local start_path = vim.fs.dirname(buf_path)

  local git_root = try_find(start_path, '.git')
  if git_root then
    return vim.fs.dirname(git_root)
  end

  local other_root = try_find(start_path, { 'Cargo.toml', 'flake.nix' })
  if other_root then
    return vim.fs.dirname(other_root)
  end

  return nil
end

local au = require('utils').au
local ag = require('utils').ag

ag('uima/SetProjectRoot', function(g)
  au({ 'BufEnter', 'LspAttach' }, {
    group = g,
    callback = function()
      local root = find_project_root()
      if root and root ~= vim.loop.cwd() then
        -- vim.print('project root: ' .. root)
        vim.cmd('lcd ' .. vim.fn.fnameescape(root))
      end
    end,
  })
end)
