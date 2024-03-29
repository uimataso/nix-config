local M = {}

local ls = require('luasnip')
-- local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
-- local events = require('luasnip.util.events')
-- local ai = require('luasnip.nodes.absolute_indexer')
-- local extras = require('luasnip.extras')
-- local l = extras.lambda
-- local rep = extras.rep
-- local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda
-- local fmt = require('luasnip.extras.fmt').fmt
-- local fmta = require('luasnip.extras.fmt').fmta
-- local conds = require('luasnip.extras.expand_conditions')
-- local postfix = require('luasnip.extras.postfix').postfix
-- local types = require('luasnip.util.types')
-- local parse = require('luasnip.util.parser').parse_snippet
-- local ms = ls.multi_snippet
-- local k = require('luasnip.nodes.key_indexer').new_key

function M.get_visual(_, parent)
  while not parent.env do
    parent = parent.snippet
  end

  return parent.env.LS_SELECT_RAW
end

function M.get_visual_node(_, parent, _, default, indent)
  local select = M.get_visual(_, parent)
  local indent_text = string.rep('\t', indent)

  if next(select) == nil then
    return sn(nil, {
      t(indent_text),
      isn(1, { i(1, default) }, '$PARENT_INDENT' .. indent_text)
    })
  end

  -- remove indent
  local context = {}
  local space = select[next(select)]:match('^(%s*)')
  for _, ele in ipairs(select) do
    table.insert(context, ele:match('^' .. space .. '(.*)'))
  end

  return sn(nil, {
    t(indent_text),
    isn(nil, { t(context) }, '$PARENT_INDENT' .. indent_text),
    i(1)
  })
end

function M.input(pos, opts)
  local default = opts and opts.default or nil
  local indent = opts and opts.indent or 0
  return r(pos, 'input', {
    d(1, M.get_visual_node, {}, { user_args = { default, indent } }),
  }, opts)
end

return M
