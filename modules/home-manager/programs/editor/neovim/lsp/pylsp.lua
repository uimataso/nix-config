return {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  single_file_support = true,

  settings = {
    pylsp = {
      plugins = {
        flake8 = { enabled = true },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
      },
    },
  },
}
