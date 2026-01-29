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

vim.lsp.config("pyright", {
    on_attach = M.on_attach,
    settings = {
        pyright = {
            autoImportCompletion = true,
        },
        python = {
            analysis = {
                autoSearchPaths = true,
                iagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'off'
            },
        },
    },
})
vim.lsp.enable("pyright")

local function switch_source_header()
    local bufnr = vim.api.nvim_get_current_buf()
    local uri = vim.uri_from_bufnr(bufnr)

    for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if client.name == "clangd" then
            client.request(
                "textDocument/switchSourceHeader",
                { uri = uri },
                function(err, result)
                    if err then
                        vim.notify(err.message or tostring(err), vim.log.levels.ERROR)
                        return
                    end
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

    vim.notify("clangd not attached", vim.log.levels.WARN)
end

vim.api.nvim_create_user_command("ClangdSwitchSourceHeader", switch_source_header, {})
