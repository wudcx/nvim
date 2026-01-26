local opt = vim.opt
local g = vim.g

-------------------------------------- globals -----------------------------------------
g.eol = true
-------------------------------------- options ------------------------------------------
opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = ""

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true
opt.colorcolumn = "80"
-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

opt.scrolloff = 10
g.mapleader = " "

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath "data" .. "/mason/bin"

-- warning/ error 错误诊断显示在行内
vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    -- severity_sort = true,
}

-- vim.g.clipboard = {
--     name = "OSC52",
--     copy = {
--         ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--         ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--     },
--     paste = {
--         ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
--         ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
--     },
-- }

local osc52 = require("vim.ui.clipboard.osc52")

vim.g.clipboard = {
  name = "OSC52-safe",

  -- 只用 OSC52 copy
  copy = {
    ["+"] = osc52.copy("+", { silent = true }),
    ["*"] = osc52.copy("*", { silent = true }),
  },

  -- paste：直接走默认（不走 OSC52）
  paste = {
    ["+"] = function()
      return vim.fn.getreg("+"), vim.fn.getregtype("+")
    end,
    ["*"] = function()
      return vim.fn.getreg("*"), vim.fn.getregtype("*")
    end,
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    if vim.bo.buftype ~= "" then
      return
    end

    local view = vim.fn.winsaveview()

    -- 删除行尾空白
    vim.cmd([[%s/\s\+$//e]])

    -- 保证文件末尾只有一个换行
    vim.cmd([[%s/\(\n\)\+\%$//e]])

    vim.fn.winrestview(view)
  end,
})
