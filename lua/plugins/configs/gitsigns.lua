local options = {
    on_attach = function(bufnr)
        require("core.utils").load_mappings("gitsigns", { buffer = bufnr })
    end,

    preview_config = {
        -- Options passed to nvim_open_win
        style = 'minimal',
        border = 'rounded',
        relative = 'cursor',
        row = 0,
        col = 1
    },
}

return options
