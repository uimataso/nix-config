vim.o.conceallevel = 0

-- format markdown table
-- ref: https://heitorpb.github.io/bla/format-tables-in-vim/
vim.keymap.set('x', '<leader>ft', ":! tr -s \" \" | column -t -s '|' -o '|'<cr>")
