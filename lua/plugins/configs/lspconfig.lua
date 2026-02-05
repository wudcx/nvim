local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
    utils.load_mappings("lspconfig", { buffer = bufnr })
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

local servers = { "html", "cssls" }

for _, lsp in ipairs(servers) do
    vim.lsp.config(lsp, {
        on_attach = M.on_attach,
        capabilities = M.capabilities
    })
    vim.lsp.enable(lsp)
end

local vue_language_server_path = vim.fn.stdpath('data') ..
    "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
}
local vtsls_config = {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = tsserver_filetypes,
}

-- If you are on most recent `nvim-lspconfig`
local vue_ls_config = {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
}
-- nvim 0.11 or above
vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)
vim.lsp.enable({ 'vtsls', 'vue_ls' }) -- If using `ts_ls` replace `vtsls` to `ts_ls`

vim.lsp.config("clangd", {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    -- cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
})

vim.lsp.enable "clangd"

vim.lsp.config("cmake", {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
})

vim.lsp.enable("cmake")

vim.lsp.config("lua_ls", {
    on_attach = M.on_attach,
    capabilities = M.capabilities,

    settings = {
        Lua = {
            diagnostics = {
                globals = { "nvim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/codecompanion.nvim/lua/codecompanion"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/telescope.nvim/lua/telescope"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/telescope.nvim/lua/telescope/pickers"] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})

vim.lsp.enable "lua_ls"

-- 配置 pyright Python LSP 服务器
vim.lsp.config("pyright", {
    on_attach = M.on_attach,  -- 使用共享的 on_attach 函数
    settings = {
        pyright = {
            autoImportCompletion = true,  -- 自动导入补全
        },
        python = {
            analysis = {
                autoSearchPaths = true,         -- 自动搜索路径
                diagnosticMode = 'openFilesOnly',  -- 仅对打开的文件进行诊断
                useLibraryCodeForTypes = true,  -- 使用库代码进行类型推断
                typeCheckingMode = 'off'        -- 关闭类型检查
            },
        },
    },
})
-- 启用 pyright LSP 服务器
vim.lsp.enable("pyright")

-- 切换 C/C++ 源文件和头文件的函数
local function switch_source_header()
    -- 获取当前缓冲区编号和 URI
    local bufnr = vim.api.nvim_get_current_buf()
    local uri = vim.uri_from_bufnr(bufnr)

    -- 遍历附加到当前缓冲区的 LSP 客户端
    for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        -- 只处理 clangd 客户端
        if client.name == "clangd" then
            -- 向 clangd 发送切换源文件/头文件的请求
            client.request(
                "textDocument/switchSourceHeader",
                { uri = uri },
                function(err, result)
                    -- 错误处理
                    if err then
                        vim.notify(err.message or tostring(err), vim.log.levels.ERROR)
                        return
                    end
                    -- 如果有对应文件则打开，否则提示
                    if result then
                        vim.cmd("edit " .. vim.uri_to_fname(result))
                    else
                        vim.notify("No corresponding file", vim.log.levels.INFO)
                    end
                end,
                bufnr
            )
            return
        end
    end

    -- 如果没有找到 clangd 客户端
    vim.notify("clangd not attached", vim.log.levels.WARN)
end

vim.api.nvim_create_user_command("ClangdSwitchSourceHeader", switch_source_header, {})
