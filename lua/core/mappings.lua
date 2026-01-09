local M = {}
M.general = {
    i = {
        -- go to  beginning and end
        ["<C-b>"] = { "<ESC>^i", "beginning of line" },
        ["<C-e>"] = { "<End>", "end of line" },

        -- navigate within insert mode
        ["<C-h>"] = { "<Left>", "move left" },
        ["<C-l>"] = { "<Right>", "move right" },
        ["<C-j>"] = { "<Down>", "move down" },
        ["<C-k>"] = { "<Up>", "move up" },
        ["jj"] = { "<ESC>", "<ESC>" },
    },
    n = {
        ["<Esc>"] = { ":noh <CR>", "clear highlights" },
        -- switch between windows
        ["<C-h>"] = { "<C-w>h", "window left" },
        ["<C-l>"] = { "<C-w>l", "window right" },
        ["<C-j>"] = { "<C-w>j", "window down" },
        ["<C-k>"] = { "<C-w>k", "window up" },

        -- save
        ["<C-s>"] = { "<cmd> w <CR>", "save file" },

        -- Copy all
        ["<C-c>"] = { "<cmd> %y+ <CR>", "copy whole file" },

        -- line numbers
        ["<leader>n"] = { "<cmd> set nu! <CR>", "toggle line number" },
        ["<leader>rn"] = { "<cmd> set rnu! <CR>", "toggle relative number" },

        -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
        -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
        -- empty mode is same as using <cmd> :map
        -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
        ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "move down", opts = { expr = true } },
        ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "move up", opts = { expr = true } },
        ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "move up", opts = { expr = true } },
        ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "move down", opts = { expr = true } },
        ["<A-o>"] = { ":ClangdSwitchSourceHeader <CR>", "switch source header" },
        -- new buffer
        ["<leader>b"] = { "<cmd> enew <CR>", "new buffer" },
        ["<leader>ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
        ["<A-j>"] = { "4<C-e>", "down 4 line" },
        ["<A-k>"] = { "4<C-y>", "up 4 line" },
        ["<S-u>"] = { ":redo <CR>", "redo" },
        ["<leader>y"] = { "\"+y", "copy" },
        ["<leader>p"] = { "\"+p", "parse" },
    },
    v = {
        ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "move up", opts = { expr = true } },
        ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "move down", opts = { expr = true } },
    },

}

M.nvimtree = {
    plugin = true,

    n = {
        -- toggle
        ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },

        -- focus
        ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
    },
}

return M