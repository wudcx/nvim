-- 阿里云 DeepSeek adapter
local aliyun_deepseek = function()
  return require("codecompanion.adapters").extend("deepseek", {
    name = "aliyun_deepseek",

    url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",

    headers = {
      ["Authorization"] = "Bearer " .. (os.getenv("ALIYUN_API_KEY") or ""),
      ["Content-Type"] = "application/json",
    },

    request = {
      enable_thinking = true,
      stream = true,
      stream_options = {
        include_usage = true,
      },
    },

    schema = {
      model = {
        default = "deepseek-v3.2",
      },
    },
  })
end

-- codecompanion 配置
local options = {
  adapters = {
    deepseek = {
        env = {
            api_key = os.getenv("DEEPSEEK_API_KEY"),
        }
    } 
  },

  strategies = {
    chat = {
      adapter = "deepseek",
    },
    inline = {
      adapter = "deepseek",
    },
  },

  opts = {
    language = "Chinese",
  },
}

return options

