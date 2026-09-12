local options = {
  ensure_installed = {
    "c",
    "cpp",
    "lua",
    "python",
    "vim",
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "tsx",
    "vue",
    "svelte",
    "astro",
    "graphql",
    "markdown",
    "markdown_inline",
    "json",
  },

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
