-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Remove LazyVim's spell autocmd for markdown (it sets spell=true by default)
vim.api.nvim_clear_autocmds({
    group = "lazyvim_wrap_spell",
    pattern = "markdown",
})

-- Disable spell and diagnostics for markdown buffers
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(ev)
        vim.opt_local.spell = false
        vim.diagnostic.enable(false, { bufnr = ev.buf })
    end,
})
