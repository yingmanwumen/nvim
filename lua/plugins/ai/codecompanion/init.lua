local slash_commands_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/slash_commands/"

local bilingual = require("plugins.ai.codecompanion.variables.bilingual")
local chinese = require("plugins.ai.codecompanion.variables.chinese")
local self_driven = require("plugins.ai.codecompanion.variables.self_driven")

local adapter = "copilot_0"

return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanionChat",
    "CodeCompanion",
    "CodeCompanionCmd",
    "CodeCompanionActions",
  },
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        local_ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = "http://localhost:11434",
            },
            schema = {
              model = {
                default = "deepseek-r1:1.5b",
              },
            },
          })
        end,
        deepseek = function()
          return require("codecompanion.adapters").extend("deepseek", {
            env = {
              api_key = os.getenv("DEEPSEEK_API_KEY"),
            },
            schema = {
              model = {
                -- default = "deepseek-chat",
                default = "deepseek-reasoner",
              },
              temperature = {
                default = 0.3,
              },
            },
          })
        end,
        copilot_0 = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              temperature = {
                default = 0,
              },
            },
          })
        end,
        copilot_0_3 = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              temperature = {
                default = 0.3,
              },
            },
          })
        end,
        copilot_0_5 = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              temperature = {
                default = 0.5,
              },
            },
          })
        end,
        copilot_0_7 = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              temperature = {
                default = 0.7,
              },
            },
          })
        end,
        copilot_1_0 = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              temperature = {
                default = 1.0,
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = adapter,
          slash_commands = {
            ["git_commit"] = {
              description = "Generate git commit message and commit it",
              callback = slash_commands_prefix .. "git_commit.lua",
              opts = {
                contains_code = true,
              },
            },
            ["git_diff"] = {
              description = "Generate git diff",
              callback = slash_commands_prefix .. "git_diff.lua",
              opts = {
                contains_code = true,
              },
            },
            ["git_files"] = {
              description = "List git files",
              callback = slash_commands_prefix .. "git_files.lua",
              opts = {
                contains_code = true,
              },
            },
          },
          variables = {
            ["chinese"] = chinese,
            ["bilingual"] = bilingual,
            ["self_driven"] = self_driven,
          },
        },
        inline = { adapter = adapter },
        agent = { adapter = adapter },
      },
      display = {
        chat = {
          icons = {
            pinned_buffer = " ",
            watched_buffer = "👀 ",
          },
          -- show_settings = true,
          window = {
            position = "right",
          },
        },
      },
      opts = {
        system_prompt = function(_)
          return [[
You are an AI programming assistant integrated into Neovim on the user's machine.

**You MUST:**
- Follow the user's requirements precisely.
- Use Markdown formatting in your responses.
- Specify the programming language at the start of code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the entire response in triple backticks.
- Provide only the relevant code for the task at hand.
- Use actual line breaks to start new lines.
- Use '\n' only for a literal backslash followed by 'n'.
- Respond in the language the user prefers.

**When given a task:**
1. Break down the task into smaller, manageable parts if necessary.
2. Think **STEP-BY-STEP** and describe your plan in pseudocode unless otherwise instructed.
3. Output the code in a single code block, ensuring relevance.
4. Review and ensure the solution is correct.
5. **ASK FOR MORE INFORMATION IF UNSURE**.
6. **RUN ONLY ONE TOOL PER CONVERSATION TURN** and wait for its result.
7. Leverage tools given to you as needed.
]]
        end,
      },
    })
  end,
}
