local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
if not vim.g.vscode then
    require("lazy").setup({
        spec = {
            -- add LazyVim and import its plugins
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            -- ai
            { import = "lazyvim.plugins.extras.ai.copilot" },
            { import = "lazyvim.plugins.extras.ai.claudecode" },
            --coding
            { import = "lazyvim.plugins.extras.coding.yanky" },
            { import = "lazyvim.plugins.extras.coding.mini-surround" },
            -- lang
            { import = "lazyvim.plugins.extras.lang.json" },
            { import = "lazyvim.plugins.extras.lang.markdown" },
            { import = "lazyvim.plugins.extras.lang.toml" },
            { import = "lazyvim.plugins.extras.lang.yaml" },
            { import = "lazyvim.plugins.extras.lang.rust" },
            { import = "lazyvim.plugins.extras.lang.python" },
            { import = "lazyvim.plugins.extras.lang.go" },
            { import = "lazyvim.plugins.extras.lang.ruby" },
            -- editor
            { import = "lazyvim.plugins.extras.editor.inc-rename" },
            { import = "lazyvim.plugins.extras.editor.dial" },
            { import = "lazyvim.plugins.extras.editor.aerial" },
            { import = "lazyvim.plugins.extras.editor.fzf" },
            { import = "lazyvim.plugins.extras.editor.snacks_explorer" },
            { import = "lazyvim.plugins.extras.editor.snacks_picker" },
            -- ui
            { import = "lazyvim.plugins.extras.ui.indent-blankline" },
            -- util
            { import = "lazyvim.plugins.extras.util.dot" },
            { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
            -- test
            { import = "lazyvim.plugins.extras.test.core" },
            { import = "plugins" },
        },
        defaults = { lazy = true, version = false },
        install = { colorscheme = { "tokyonight", "habamax" } },
        checker = { enabled = true, notify = false },
        performance = {
            rtp = {
                -- disable some rtp plugins
                disabled_plugins = {
                    "gzip",
                    -- "matchit",
                    -- "matchparen",
                    -- "netrwPlugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
    })
else
    require("lazy").setup({
        spec = {
            -- add LazyVim and import its plugins
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            { import = "lazyvim.plugins.extras.vscode" },
            { import = "plugins" },
        },
        defaults = {
            lazy = false,
            version = false,
        },
        checker = { enabled = true }, -- automatically check for plugin updates
        performance = {
            rtp = {
                disabled_plugins = {
                    "gzip",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
    })
end
