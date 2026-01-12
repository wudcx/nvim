local default_plugins = {
    -- file managing , picker etc
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
    {
        "nvim-telescope/telescope.nvim",
        tag = "v0.1.9",
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

    {
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.10.0",
        -- init = function()
        --     require("core.utils").lazy_load "nvim-treesitter"
        -- end,
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate",
        opts = function()
            return require "plugins.configs.treesitter"
        end,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    -- lsp stuff
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        opts = function()
            return require "plugins.configs.mason"
        end,
        config = function(_, opts)
            require("mason").setup(opts)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        tag = "v2.3.0",
        config = function()
            require "plugins.configs.lspconfig"
        end,
    },

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
        -- opts = function()
        --     return require("plugins.configs.blankline")
        -- end,
        config = function(_, opts)
            require("ibl").setup()
        end,
    },

        -- load luasnips + cmp related in insert mode only
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
    {
        "supermaven-inc/supermaven-nvim",
        -- init = function ()
        --     require("core.utils").lazy_load "supermaven-nvim"
        -- end,
        opts = function()
            return require "plugins.configs.supermaven"
        end,
        config = function(_, opts)
            require("supermaven-nvim").setup(opts)
        end
    },
}

local config = require("core.utils").load_config()

require("lazy").setup(default_plugins, config.lazy_nvim)