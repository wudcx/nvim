local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Logo（你可以随意替换）
dashboard.section.header.val = {
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██║   ██║██║████╗ ████║",
    "██╔██╗ ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝         ",
}

-- 按钮区
dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
    dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
}

-- 底部提示
dashboard.section.footer.val = function()
    return "Neovim " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
end

-- 布局微调（让它更像 NvChad）
dashboard.config.layout = {
    { type = "padding", val = 2 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    { type = "padding", val = 1 },
    dashboard.section.footer,
}

dashboard.config.opts = {
    position = "center",
}

-- 当没有文件参数启动 nvim 时才显示
alpha.setup(dashboard.config)

-- 关闭 alpha 时恢复状态栏等
vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
        vim.opt.laststatus = 0
    end,
})

vim.api.nvim_create_autocmd("BufUnload", {
    buffer = 0,
    callback = function()
        vim.opt.laststatus = 2
    end,
})
