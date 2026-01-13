local options = {
  shell = vim.o.shell,

  -- 默认方向（可被 :ToggleTerm direction= 覆盖）
  direction = "float",

  -- 浮动终端样式
  float_opts = {
    border = "single",
    winblend = 0,
    width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.125),
  },

  -- horizontal / vertical 的尺寸控制
  size = function(term)
    if term.direction == "horizontal" then
      return vim.o.lines * 1 -- 等价于 nvterm 的 split_ratio = 1
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5 -- 等价于 split_ratio = .5
    end
  end,
}

return options
