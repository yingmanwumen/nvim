local tools_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/tools/"

return {
  tools = {
    ["tavily"] = {
      callback = tools_prefix .. "tavily.lua",
      description = "Online Search Tool",
      opts = {
        user_approval = true,
        hide_output = true,
      },
    },
    ["nvim_runner"] = {
      callback = tools_prefix .. "nvim_runner.lua",
      description = "Nvim Command Runner Tool",
      opts = {
        user_approval = true,
        hide_output = false,
      },
    },
    ["rag"] = {
      callback = tools_prefix .. "jina.lua",
      description = "RAG Tool",
      opts = {
        user_approval = false,
        hide_output = true,
      },
    },
  },
}
