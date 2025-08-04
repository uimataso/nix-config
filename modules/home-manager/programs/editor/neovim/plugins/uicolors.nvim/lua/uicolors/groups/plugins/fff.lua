local M = {}

M.url = 'https://github.com/dmtrKovalenko/fff.nvim'

M.get = function(c)
  return {
    -- Symbol highlights
    FFFGitStaged = 'GitSignsStagedAdd',
    FFFGitModified = 'GitSignsChange',
    FFFGitDeleted = 'GitSignsDelete',
    FFFGitRenamed = 'GitSignsChange',
    FFFGitUntracked = 'GitSignsUntracked',
    FFFGitIgnored = 'NonText',

    -- Thin border highlights
    FFFGitSignStaged = 'FFFGitStaged',
    FFFGitSignModified = 'FFFGitModified',
    FFFGitSignDeleted = 'FFFGitDeleted',
    FFFGitSignRenamed = 'FFFGitRenamed',
    FFFGitSignUntracked = 'FFFGitUntracked',
    FFFGitSignIgnored = 'FFFGitIgnored',
  }
end

return M
