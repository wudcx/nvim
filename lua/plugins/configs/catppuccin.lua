local options = {
    all = {
        text = "#ffffff",
    },
    latte = {
        base = "#ff0000",
        mantle = "#242424",
        crust = "#474747",
    },
    frappe = {},
    macchiato = {},
    mocha = {},
    custom_highlights = function(colors)
        return {
            Comment = { fg = colors.flamingo },
            TabLineSel = { bg = colors.pink },
            CmpBorder = { fg = colors.surface2 },
            Pmenu = { bg = colors.none },
        }
    end
}

return options
