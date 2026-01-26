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

-- TypeScript / JavaScript
vim.lsp.config("vtsls", {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find({ 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }, { upward = true, path = fname })[1])
  end,
})

vim.lsp.enable("vtsls")


-- Vue (Volar)
vim.lsp.config("vue_ls", {
  filetypes = { "vue" },
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find({ 'package.json', 'vue.config.js', 'vite.config.js', '.git' }, { upward = true, path = fname })[1])
  end,
})

vim.lsp.enable("vue_ls")

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

