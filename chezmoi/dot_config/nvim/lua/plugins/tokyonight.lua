return {
    "folke/tokyonight.nvim",
    opts = {
        transparent = true,
        styles = {
            sidebars = "transparent",
            floats = "transparent",
        },
        on_highlights = function(hl, c)
            -- 境界線の色を白に設定
            hl.WinSeparator = {
                fg = "#888888", -- 白
                bold = true, -- 太字（任意）
            }
            -- 浮いているウィンドウ（LazyやMasonなど）の境界線も白くする場合
            hl.FloatBorder = {
                fg = "#888888",
            }
        end,
    },
}
