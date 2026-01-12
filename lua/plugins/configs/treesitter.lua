local options = {
  ensure_installed = { "c", "cpp", "lua", "python" },

  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = true
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    }
  },

  indent = { enable = true },
}

return options
