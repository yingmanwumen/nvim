return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or
      { "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    -- See Commands section for default commands if you want to lazy load on them
    event = "VeryLazy",
    cmd = {
      "CopilotChat",
      "CopilotChatCommit",
      "CopilotChatExplain",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatReview",
      "CopilotChatTests",
    },
    opts = {
      temperature = 0.7,
      -- model = "o1",
    },
  },
}
