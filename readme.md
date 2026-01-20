# Neovim 配置教程 - 基于你的自定义配置

## 目录
1. [简介](#简介)
2. [项目结构](#项目结构)
3. [核心配置](#核心配置)
4. [插件配置详解](#插件配置详解)
5. [映射配置](#映射配置)
6. [实用技巧](#实用技巧)

## 简介

这是一个基于 Lua 编写的 Neovim 配置，采用模块化设计，利用 lazy.nvim 作为插件管理器，集成了多种现代编辑功能。此配置借鉴了 NvChad 的设计理念，提供了开箱即用的开发环境。

## 项目结构

```
lua/
├── core/                 # 核心配置
│   ├── bootstrap.lua     # 启动配置
│   ├── default_config.lua # 默认配置
│   ├── init.lua          # 核心选项
│   ├── mappings.lua      # 键位映射
│   └── utils.lua         # 工具函数
└── plugins/              # 插件配置
    └── configs/          # 各插件具体配置
    └── init.lua          # 插件管理入口
```

### 主要文件说明：

- **init.lua** - 入口文件，初始化整个配置
- **core/** - 包含核心设置和通用工具
- **plugins/** - 管理所有插件及其配置

## 核心配置

### 1. core/init.lua

这个文件包含 Neovim 的基础设置：

```lua
-- 设置全局变量
g.eol = true

-- 选项配置
opt.laststatus = 3          -- 全局状态栏
opt.showmode = false        -- 隐藏模式指示器
opt.clipboard = "unnamedplus" -- 使用系统剪贴板
opt.cursorline = true       -- 高亮当前行
opt.expandtab = true        -- 将 Tab 转换为空格
opt.shiftwidth = 4          -- 缩进宽度
opt.tabstop = 4             -- Tab 显示宽度
opt.number = true           -- 显示行号
opt.relativenumber = true   -- 显示相对行号
opt.colorcolumn = "80"      -- 在第80列显示垂直线
```

### 2. core/bootstrap.lua

负责安装和初始化 lazy.nvim：

```lua
M.echo = function(str)
    vim.cmd "redraw"
    vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

M.lazy = function(install_path)
    M.echo "安装 lazy.nvim & 插件 ..."
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", repo, install_path }
    vim.opt.rtp:prepend(install_path)
end
```

### 3. core/default_config.lua

定义默认配置：

```lua
M.ui = {
  cmp = {                  -- 自动补全界面配置
    icons = true,
    style = "default",     -- 补全菜单样式
    border_color = "grey_fg",
    selected_item_bg = "colored"
  },
}

M.lazy_nvim = require "plugins.configs.lazy_nvim"  -- lazy.nvim 配置
M.mappings = require "core.mappings"               -- 键位映射
```

## 插件配置详解

### 1. 启动画面 - Alpha

**文件**: `/plugins/configs/alpha.lua`

Alpha 是一个启动画面插件，显示自定义 logo 和快捷按钮。

```lua
-- Logo 区域
dashboard.section.header.val = {
    -- ASCII 艺术 logo
    "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
    -- 更多行...
}

-- 按钮区域
dashboard.section.buttons.val = {
    dashboard.button("e", "新文件", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "查找文件", ":Telescope find_files<CR>"),
    -- 更多按钮...
}
```

**功能**:
- 启动 Neovim 时显示自定义界面
- 提供快速访问文件、设置等功能的按钮

### 2. 主题 - Catppuccin

**文件**: [/plugins/configs/catppuccin.lua](file:///home/wdc/code/nvim/lua/plugins/configs/catppuccin.lua)

Catppuccin 是一款流行的浅色/深色主题集合。

```lua
local options = {
    all = {
        text = "#ffffff",  -- 文本颜色
    },
    latte = {
        base = "#ff0000",  -- Latte 主题基础色
        mantle = "#242424", -- Latte 主题次要背景色
        crust = "#474747", -- Latte 主题边框色
    },
    -- Frappé, Macchiato, Mocha 等其他主题配置
    custom_highlights = function(colors)  -- 自定义高亮
        return {
            Comment = { fg = colors.flamingo },
            TabLineSel = { bg = colors.pink },
            -- 更多自定义...
        }
    end
}
```

**功能**:
- 提供多种配色方案
- 支持自定义高亮

### 3. 文件管理 - NvimTree

**文件**: [/plugins/configs/nvimtree.lua](file:///home/wdc/code/nvim/lua/plugins/configs/nvimtree.lua)

NvimTree 是一个文件树浏览器。

```lua
local options = {
  filters = {
    dotfiles = false,                    -- 不显示隐藏文件
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" }, -- 排除特定路径
  },
  disable_netrw = true,                 -- 禁用内置 netrw
  hijack_netrw = true,                  -- 替代 netrw
  sync_root_with_cwd = true,            -- 同步根目录与工作目录
  view = {
    adaptive_size = false,
    side = "left",                      -- 文件树位置
    width = 30,                         -- 文件树宽度
  },
  -- 更多配置...
}
```

**键位映射**:
- `<C-n>` - 切换文件树显示/隐藏
- `<leader>e` - 聚焦文件树

### 4. 文件搜索 - Telescope

**文件**: [/plugins/configs/telescope.lua](file:///home/wdc/code/nvim/lua/plugins/configs/telescope.lua)

Telescope 是一个强大的模糊查找器。

```lua
local options = {
    defaults = {
        prompt_prefix = "   ",          -- 提示符前缀
        selection_caret = "  ",          -- 选择项标记
        layout_strategy = "horizontal",  -- 布局策略
        layout_config = {
            horizontal = {
                prompt_position = "top", -- 提示符位置
                preview_width = 0.55,    -- 预览窗宽度比例
            },
        },
        -- 更多配置...
    },
}
```

**键位映射**:
- `<leader>ff` - 查找文件
- `<leader>fw` - 实时搜索
- `<leader>fb` - 查找缓冲区
- `<leader>fh` - 查找帮助页面

### 5. 语法高亮 - Treesitter

**文件**: `/plugins/configs/treesitter.lua**

Treesitter 提供基于语法树的高亮。

```lua
local options = {
  ensure_installed = { 
    "c", "cpp", "lua", "python",        -- 确保安装的语言解析器
    "vim", "html", "css", "javascript",
    "typescript", "tsx", "markdown",
    "markdown_inline",
  },

  highlight = {
    enable = true,                      -- 启用语法高亮
    use_languagetree = true,
    additional_vim_regex_highlighting = true
  },
  
  incremental_selection = {
    enable = true,                      -- 启用增量选择
    keymaps = {
      init_selection = '<CR>',          -- 初始化选择
      node_incremental = '<CR>',        -- 增量选择节点
      node_decremental = '<BS>',        -- 减量选择节点
    }
  },
}
```

### 6. LSP 配置 - LSPConfig

**文件**: `/plugins/configs/lspconfig.lua`

LSP (Language Server Protocol) 提供代码补全、诊断等功能。

```lua
M.on_attach = function(client, bufnr)
    utils.load_mappings("lspconfig", { buffer = bufnr })  -- 加载 LSP 相关映射
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- 配置各种语言服务器
local servers = { "html", "cssls", "ts_ls" }

for _, lsp in ipairs(servers) do
    vim.lsp.config(lsp, {
        on_attach = M.on_attach,
        capabilities = M.capabilities
    })
    vim.lsp.enable(lsp)
end
```

**LSP 键位映射**:
- `gd` - 跳转到定义
- `gD` - 跳转到声明
- `gi` - 跳转到实现
- `gr` - 查找引用
- `<leader>ca` - 代码操作
- `<leader>fm` - 格式化代码

### 7. 自动补全 - CMP

**文件**: [/plugins/configs/cmp.lua](file:///home/wdc/code/nvim/lua/plugins/configs/cmp.lua)

CMP 是一个现代的自动补全框架。

```lua
local options = {
    completion = {
        completeopt = "menu,menuone",    -- 补全选项
    },

    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),  -- 上一项
        ["<C-n>"] = cmp.mapping.select_next_item(),  -- 下一项
        ["<C-Space>"] = cmp.mapping.complete(),      -- 触发补全
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        -- Tab 键映射处理
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    
    sources = {
        { name = "nvim_lsp" },           -- LSP 补全源
        { name = "luasnip" },           -- 代码片段
        { name = "buffer" },            -- 当前缓冲区
        { name = "path" },              -- 文件路径
    },
}
```

### 8. 终端模拟器 - Toggleterm

**文件**: [/plugins/configs/toggleterm.lua](file:///home/wdc/code/nvim/lua/plugins/configs/toggleterm.lua)

Toggleterm 提供浮动终端功能。

```lua
local options = {
  shell = vim.o.shell,                  -- 使用当前 shell
  direction = "float",                  -- 默认方向为浮动
  float_opts = {
    border = "single",                  -- 边框样式
    width = function() return math.floor(vim.o.columns * 0.75) end,  -- 宽度
    height = function() return math.floor(vim.o.lines * 0.75) end,   -- 高度
  },
}
```

**键位映射**:
- `<A-i>` - 切换浮动终端
- `<A-h>` - 切换水平终端
- `<A-v>` - 切换垂直终端

### 9. AI 代码助手 - CodeCompanion

**文件**: [/plugins/configs/codecompanion.lua](file:///home/wdc/code/nvim/lua/plugins/configs/codecompanion.lua)

CodeCompanion 提供 AI 驱动的代码补全和聊天功能。

```lua
local options = {
  adapters = {
    deepseek = {
        env = {
            api_key = os.getenv("DEEPSEEK_API_KEY"),  -- API 密钥
        }
    } 
  },

  strategies = {
    chat = { adapter = "deepseek" },    -- 聊天策略
    inline = { adapter = "deepseek" },  -- 内联补全策略
  },

  opts = {
    language = "Chinese",               -- 使用中文
  },
}
```

### 10. 代码片段 - Luasnip

**文件**: [/plugins/configs/others.lua](file:///home/wdc/code/nvim/lua/plugins/configs/others.lua)

Luasnip 是一个功能强大的代码片段引擎。

```lua
M.luasnip = function(opts)
  require("luasnip").config.set_config(opts)

  -- 加载不同格式的代码片段
  require("luasnip.loaders.from_vscode").lazy_load()    -- VSCode 格式
  require("luasnip.loaders.from_snipmate").load()       -- Snipmate 格式
  require("luasnip.loaders.from_lua").load()            -- Lua 格式

  -- 退出插入模式时取消链接当前片段
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      if require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()] then
        require("luasnip").unlink_current()
      end
    end,
  })
end
```

## 映射配置

**文件**: [/core/mappings.lua](file:///home/wdc/code/nvim/lua/core/mappings.lua)

这个文件定义了所有的键盘映射。

### 通用映射 (General)

```lua
M.general = {
    i = {  -- 插入模式
        ["<C-b>"] = { "<ESC>^i", "行首" },
        ["<C-e>"] = { "<End>", "行尾" },
        ["<C-h>"] = { "<Left>", "左移" },
        ["<C-l>"] = { "<Right>", "右移" },
        ["jj"] = { "<ESC>", "退出插入模式" },
    },
    n = {  -- 正常模式
        ["<C-s>"] = { "<cmd> w <CR>", "保存文件" },
        ["<leader>n"] = { "<cmd> set nu! <CR>", "切换行号" },
        ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "查找文件" },
        -- 更多映射...
    },
}
```

### 主要映射说明

#### 窗口操作
- `<C-h>` / `<C-l>` / `<C-j>` / `<C-k>` - 在窗口间移动光标

#### 文件操作
- `<C-s>` - 保存文件
- `<leader>b` - 新建缓冲区
- `<C-n>` - 打开/关闭文件树
- `<leader>e` - 聚焦文件树

#### 搜索操作
- `<leader>ff` - 查找文件
- `<leader>fw` - 实时搜索
- `<leader>fb` - 查找缓冲区

#### LSP 操作
- `gd` - 跳转到定义
- `gD` - 跳转到声明
- `<leader>ca` - 代码操作
- `<leader>fm` - 格式化代码

## 实用技巧

### 1. 安装新插件
在 [/plugins/init.lua](file:///home/wdc/code/nvim/lua/plugins/init.lua) 中添加新的插件条目：

```lua
{
    "作者/仓库名",
    lazy = false,  -- 或 true，根据需要
    config = function()
        require("插件名").setup({})
    end,
}
```

### 2. 自定义键位映射
修改 [/core/mappings.lua](file:///home/wdc/code/nvim/lua/core/mappings.lua) 文件，在相应模式下添加映射：

```lua
["<leader>m"] = { ":MyCommand<CR>", "我的命令" }
```

### 3. 添加语言服务器支持
在 `/plugins/configs/lspconfig.lua` 中添加新的语言服务器：

```lua
vim.lsp.config("新语言服务器名称", {
    on_attach = M.on_attach,
    capabilities = M.capabilities
})
vim.lsp.enable("新语言服务器名称")
```

### 4. 故障排除
- 如果插件无法正常工作，运行 `:Lazy` 检查插件状态
- 使用 `:checkhealth` 检查 Neovim 环境
- 运行 `:Mason` 检查语言服务器安装状态

### 5. 性能优化
- lazy.nvim 会在需要时才加载插件，提高启动速度
- 部分插件设置了延迟加载，如 treesitter 在打开文件时才加载
- 可以在 [plugins/configs/lazy_nvim.lua](file:///home/wdc/code/nvim/lua/plugins/configs/lazy_nvim.lua) 中禁用不需要的插件

这个配置提供了一个现代化的 Neovim 开发环境，集成了 AI 功能、强大的补全系统、LSP 支持等多种功能，适合日常开发使用。


