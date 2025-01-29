return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanionChat",
    "CodeCompanion",
    "CodeCompanionCmd",
    "CodeCompanionActions",
  },
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        deepseek = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://api.deepseek.com",
              api_key = os.getenv("DEEPSEEK_API_KEY"),
            },
            schema = {
              -- model = {
              --   default = "deepseek-chat",
              -- },
              temperature = {
                default = 0.5,
              },
            },
          })
        end,
      },
      strategies = {
        -- chat = { adapter = "deepseek" },
        -- inline = { adapter = "deepseek" },
        -- agent = { adapter = "deepseek" },
        chat = {
          adapter = "copilot",
          variables = {
            ["just_do_it"] = {
              callback = function()
                return [[
### You have gained access to run commands directly from Command Runner Tool!

Premise:
- You should have gained access to Command Runner Tool.
- Assume commands are under Linux/MacOS.

You can:
- Take advantage of Command Runner Tool to run commands to seek information which you need but lack to complete the given mission.

You should:
- You should do what you can do without any confirmation. Just Do it.
- You should use Command Runner Tool when you need to seek information from the Internet but the RAG cannot work, 
- You should explain your intention before giving your command (why you should to do it and how it works, if possible).
- You should give all your output in a nice format to read. For instance:

```
Why:
- ...

How it works:
- ...
```

]]
              end,
              description = "Automated",
              opts = {
                contains_code = false,
              },
            },
          },
        },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },
      display = {
        chat = {
          window = {
            position = "right",
          },
        },
      },
    })
  end,
}
