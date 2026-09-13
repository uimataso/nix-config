local U = require('uima')

local OrgCapture = {}

--- Stash the active visual selection + its source context (path, line
--- range, filetype). Called from <Leader>oc while the source buffer is
--- still current. No-op when there is no active selection.
function OrgCapture.capture()
  local lines = U.get_selected_lines()
  if not lines then
    OrgCapture._stash = nil
    return
  end
  local a, b = U.get_selected_range()
  local path = vim.fn.expand('%:p')
  local cwd = (vim.uv and vim.uv.cwd() or vim.loop.cwd()) .. '/'
  local rel = path:gsub('^' .. vim.pesc(cwd), '')
  local ft = vim.bo.filetype
  OrgCapture._stash = {
    text = table.concat(U.unindent(lines), '\n'),
    ft = (ft and ft ~= '') and ft or 'text',
    path = path, -- absolute: orgmode only resolves /abs, ~/, ./, ../
    rel = rel, -- short display text, relative to cwd
    a = a,
    b = b,
  }
end

--- Build the capture body from the stash: an org file link in
--- `path:line[-range]` style followed by the selection wrapped in a
--- `#+begin_src <filetype>` block. Returns '' when nothing was stashed.
function OrgCapture.drain_selection()
  local s = OrgCapture._stash
  OrgCapture._stash = nil
  if not s then
    return ''
  end
  local range_str = s.a == s.b and tostring(s.a) or (s.a .. '-' .. s.b)
  local link = ('[[file:%s::%d][%s:%s]]'):format(s.path, s.a, s.rel, range_str)
  local block = ('#+begin_src %s\n%s\n#+end_src'):format(s.ft, s.text)
  return '\n' .. link .. '\n' .. block
end

-- Exposed on _G so org capture template expressions (`load()`-ed with the
-- global env) can drain it.
_G.OrgCapture = OrgCapture

local M = {}

M.capture = OrgCapture.capture

--- Append the stashed visual selection (if any) to a capture template.
function M.with_selection(template)
  return template .. '\n%(return _G.OrgCapture.drain_selection())'
end

return M
