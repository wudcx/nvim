local options = {}

options = {
    debounce = 300,
    scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        highlight = "IblScope",

        include = {
            node_type = {
                cpp = {
                    "compound_statement",
                    "function_definition",
                    "if_statement",
                    "for_statement",
                    "while_statement",
                    "switch_statement",
                    "class_specifier",
                    "namespace_definition",
                },
            },
        },
    }

}

return options
