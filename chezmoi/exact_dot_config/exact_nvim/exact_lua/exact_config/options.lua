-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.wo.wrap = true -- 行の折り返しを有効化
vim.wo.linebreak = true -- 単語の途中での折り返しを防ぐ
vim.wo.list = true -- 制御文字（タブや行末の空白など）の可視化

vim.opt.scrolloff = 4 -- カーソルが画面の端に来たとき、上下に最低 8 行の余白を保つ。
vim.opt.termguicolors = true -- カーソルが画面の端に来たとき、上下に最低 8 行の余白を保つ。
vim.opt.winblend = 0 -- ウィンドウの不透明度
vim.opt.pumblend = 0 -- ポップアップメニューの不透明度
vim.opt.shiftwidth = 4 -- Size of an indent

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("osc52", { clear = true }),
    callback = function()
        -- vim.print(vim.v.event)
        if vim.v.operator == "y" then
            require("vim.ui.clipboard.osc52").copy("+")(vim.v.event.regcontents)
            -- require("osc52").copy_register("+")
        end
    end,
})

-- https://zenn.dev/kakifl/articles/vscode-vim-to-neovim
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"

-- ai comp true
vim.g.ai_cmp = true

-- Set default shell to zsh
vim.opt.shell = "/bin/zsh"
