local map = LazyVim.safe_keymap_set

-- Ctrl+a で行の先頭に移動（Emacs風）
vim.api.nvim_set_keymap("i", "<C-a>", "<Home>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-a>", "^", { noremap = true })
vim.api.nvim_set_keymap("v", "<C-a>", "^", { noremap = true })

-- Ctrl+e で行の末尾に移動（Emacs風）
vim.api.nvim_set_keymap("i", "<C-e>", "<End>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-e>", "$", { noremap = true })
vim.api.nvim_set_keymap("v", "<C-e>", "$", { noremap = true })

-- insert modeの際に移動する方法
vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", { noremap = true })
