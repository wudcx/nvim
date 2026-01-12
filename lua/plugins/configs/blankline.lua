local options = {}

options = {
  filetype_exclude = {
    "help",
    "terminal",
    "lazy",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "",
  },
  buftype_exclude = { "terminal" },
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
}

return options