-- Configure Claude Code to appear on the right side
return {
    "coder/claudecode.nvim",
    opts = {
        terminal_cmd = "SHELL=/bin/sh claude",
        terminal = {
            snacks_win_opts = {
                position = "right",
                width = 0.4, -- 40% of screen width
                height = 1.0, -- Full height
                border = "rounded",
            },
        },
    },
}
