local default_plugins = {
    -- alpha， 状态栏
    {
        'goolord/alpha-nvim',
        lazy = false,
        config = function()
            require("plugins.configs.alpha")
        end
    },
    -- lualine， 状态栏
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("lualine").setup()
        end
    },
    {
        'akinsho/bufferline.nvim',
        lazy = false,
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup()
        end
    },

    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     lazy = false,
    --     priority = 1000,
    --     opts = function()
    --         return require "plugins.configs.catppuccin"
    --     end,
    --     config = function(_, opts)
    --         require("catppuccin").setup(opts)
    --         vim.cmd.colorscheme "catppuccin"
    --     end
    -- },

    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "tokyonight"
        end
    },

    -- file managing , picker etc， 文件管理器
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        init = function()
            require("core.utils").load_mappings "nvimtree"
        end,
        opts = function()
            return require "plugins.configs.nvimtree"
        end,
        config = function(_, opts)
            require("nvim-tree").setup(opts)
        end,
    },

    -- file tree， 文件树
    {
        "nvim-telescope/telescope.nvim",
        -- tag = "v0.1.9",
        cmd = "Telescope",
        init = function()
            require("core.utils").load_mappings "telescope"
        end,
        opts = function()
            return require "plugins.configs.telescope"
        end,
        config = function(_, opts)
            local telescope = require "telescope"
            telescope.setup(opts)

            -- load extensions
            -- for _, ext in ipairs(opts.extensions_list) do
            --     telescope.load_extension(ext)
            -- end
        end,
    },
    -- tree sitter， 语法高亮
    {
        "nvim-treesitter/nvim-treesitter",
        -- tag = "v0.10.0",
        init = function()
            require("core.utils").lazy_load "nvim-treesitter"
        end,
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate",
        opts = function()
            return require "plugins.configs.treesitter"
        end,
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end,
    },
    -- lsp stuff， 安装语言服务器、调试器和其他开发工具
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        opts = function()
            return require "plugins.configs.mason"
        end,
        config = function(_, opts)
            require("mason").setup(opts)

            vim.api.nvim_create_user_command("MasonInstallAll", function()
                vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
            end, {})

            vim.g.mason_binaries_list = opts.ensure_installed
        end,
    },

    -- lsp config， 语言服务器配置
    {
        "neovim/nvim-lspconfig",
        init = function()
            require("core.utils").lazy_load "nvim-lspconfig"
        end,
        -- tag = "v2.3.0",
        config = function()
            require "plugins.configs.lspconfig"
        end,
    },

    -- hop plugin , 快速跳转
    {
        "phaazon/hop.nvim",
        cmd = { "HopWord", "HopChar1" },
        init = function()
            require("core.utils").load_mappings "hop"
        end,
        branch = "v2.0",
        config = function()
            require("hop").setup()
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        init = function()
            require("core.utils").lazy_load "indent-blankline.nvim"
        end,
        opts = function()
            return require("plugins.configs.blankline")
        end,
        config = function(_, opts)
            require("ibl").setup(opts)
        end,
    },

    -- load luasnips + cmp related in insert mode only， 补全
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                -- snippet plugin
                "L3MON4D3/LuaSnip",
                dependencies = "rafamadriz/friendly-snippets",
                opts = { history = true, updateevents = "TextChanged,TextChangedI" },
                config = function(_, opts)
                    require("plugins.configs.others").luasnip(opts)
                end,
            },

            -- autopairing of (){}[] etc
            {
                "windwp/nvim-autopairs",
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
                config = function(_, opts)
                    require("nvim-autopairs").setup(opts)

                    -- setup cmp for autopairs
                    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
                    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end,
            },

            -- cmp sources plugins
            {
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
            },
        },
        opts = function()
            return require "plugins.configs.cmp"
        end,
        config = function(_, opts)
            require("cmp").setup(opts)
        end,
    },
    -- AI 代码补全
    {
        "supermaven-inc/supermaven-nvim",
        init = function()
            require("core.utils").lazy_load "supermaven-nvim"
        end,
        opts = function()
            return require "plugins.configs.supermaven"
        end,
        config = function(_, opts)
            require("supermaven-nvim").setup(opts)
        end
    },
    -- 面板插件
    {
        "folke/which-key.nvim",
        keys = { "<leader>", '"', "'", "`", "c", "v" },
        init = function()
            require("core.utils").load_mappings "whichkey"
        end,
        config = function(_, opts)
            require("which-key").setup(opts)
        end,
    },
    -- 注释插件
    {
        "numToStr/Comment.nvim",
        keys = { "gcc", "gbc" },
        init = function()
            require("core.utils").load_mappings "comment"
        end,
        config = function()
            require("Comment").setup()
        end,
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        lazy = false,
        init = function()
            require("core.utils").load_mappings "toggleterm"
        end,
        opts = function()
            return require("plugins.configs.toggleterm")
        end,
        config = function(_, opts)
            require("toggleterm").setup(opts)
            vim.api.nvim_create_user_command("ToggletermList", function()
                local terms = require("toggleterm.terminal").get_all()
                if vim.tbl_isempty(terms) then
                    print("No terminals created yet")
                    return
                end

                for id, term in pairs(terms) do
                    print(string.format("Terminal %d (%s)", id, term.direction))
                end
            end, {})
        end,
    },

    -- {
    --     "ojroques/nvim-osc52",
    --     lazy = false,
    --     init = function()
    --         -- require("core.utils").lazy_load "nvim-osc52"
    --         require("core.utils").load_mappings "osc52"
    --     end,
    --     opts = function()
    --         return require "plugins.configs.osc52"
    --     end,
    --     config = function(_, opts)
    --         require("osc52").setup(opts)
    --     end,
    -- },
    {
        "olimorris/codecompanion.nvim",
        -- cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionEdit" }, -- 延迟加载
        lazy = false,
        -- init = function()
        --     require("core.utils").lazy_load "codecompanion.nvim"
        -- end,

        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = function()
            return require "plugins.configs.codecompanion"
        end,
        config = function(_, opts)
            require("codecompanion").setup(opts)
        end,
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
    },

    {
        "echasnovski/mini.diff",
        config = function()
            local diff = require("mini.diff")
            diff.setup({
                source = diff.gen_source.none(),
            })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        ft = { "gitcommit", "diff" },
        init = function()
            -- load gitsigns only when a git file is opened
            vim.api.nvim_create_autocmd({ "BufRead" }, {
                group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
                callback = function()
                    vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
                    if vim.v.shell_error == 0 then
                        vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
                        vim.schedule(function()
                            require("lazy").load { plugins = { "gitsigns.nvim" } }
                        end)
                    end
                end,
            })

        end,
        opts = function()
            return require("plugins.configs.gitsigns")
        end,
        config = function(_, opts)
            require("gitsigns").setup(opts)
        end,
    },
}

local config = require("core.utils").load_config()

require("lazy").setup(default_plugins, config.lazy_nvim)
