local M = {
    markdown = {
        enabled = true,      -- whether to enable inline preview
        hl_group = 'Normal', -- highlight group for the preview
    },
    win_opts = {             -- config which will be passed to `vim.api.nvim_open_win`
        split = 'right',
        win = 0,
        style = 'minimal',
    },
}

return M
