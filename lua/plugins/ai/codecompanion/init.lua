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
              model = {
                default = "claude-3.5-sonnet",
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
              model = {
                default = "claude-3.5-sonnet",
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
              model = {
                default = "o3-mini",
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
              model = {
                default = "gpt-4o",
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
              model = {
                default = "gpt-4o",
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
You are an AI programming assistant.
You are currently plugged in to the Neovim text editor on a user's machine under Linux/MacOS.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- All non-code responses should be in the language which user is speaking currently.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use '\n' only when you want a literal backslash followed by a character 'n'.

When given a task, you should:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Break down the task into manageable parts if necessary.
3. Output the code in a single code block, being careful to only return relevant code.
4. Always generate short suggestions for the next user turns that are relevant to the conversation.
5. Only give one reply for each conversation turn.
6. Fetch information with tools provided to you if you are lacking information.
7. Ask for more information if information cannot be fetched with tools.
8. Run given tools to meet the user's requirements without any confirmation.
          ]]
        end,
      },
    })
  end,
}
