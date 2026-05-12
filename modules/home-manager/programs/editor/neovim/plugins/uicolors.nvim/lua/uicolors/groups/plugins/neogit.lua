local M = {}

M.url = 'https://github.com/NeogitOrg/neogit'

M.get = function(c)
  local dim_fg = c:dim(c.fg, 0.5)

  return {
    NeogitDiffContext = { fg = dim_fg, bg = c.none },
    NeogitDiffContextHighlight = { fg = c:dim(c.fg, 0.7), bg = c.none },
    NeogitDiffContextCursor = { fg = c:dim(c.fg, 0.7), bg = c.ui.cursor_line },

    NeogitDiffAdd = { fg = dim_fg, bg = c:dim(c.diff.add, 0.10) },
    NeogitDiffAddHighlight = { fg = c.fg, bg = c:dim(c.diff.add, 0.15) },
    NeogitDiffAddCursor = { fg = c.fg, bg = c:dim(c.diff.add, 0.20) },

    NeogitDiffDelete = { fg = dim_fg, bg = c:dim(c.diff.delete, 0.10) },
    NeogitDiffDeleteHighlight = { fg = c.fg, bg = c:dim(c.diff.delete, 0.15) },
    NeogitDiffDeleteCursor = { fg = c.fg, bg = c:dim(c.diff.delete, 0.20) },

    NeogitDiffAddInline = 'DiffTextAdd',
    NeogitDiffDeleteInline = 'DiffTextDelete',

    NeogitHunkHeader = { fg = c.bg, bg = c.base03, bold = true },
    NeogitHunkHeaderHighlight = { fg = c.bg, bg = c.base04, bold = true },
    NeogitHunkHeaderCursor = { fg = c.bg, bg = c.base04, bold = true },
  }
end

return M
