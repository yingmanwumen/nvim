local slash_commands_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/slash_commands/"
local tools_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/tools/"

local bilingual = require("plugins.ai.codecompanion.variables.bilingual")
local chinese = require("plugins.ai.codecompanion.variables.chinese")
local codeforces_companion = require("plugins.ai.codecompanion.variables.codeforces_companion")
local emoji = require("plugins.ai.codecompanion.variables.emoji")

local adapter = "copilot_0_3"

return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanionChat",
    "CodeCompanion",
    "CodeCompanionCmd",
    "CodeCompanionActions",
  },
  event = "VeryLazy",
  keys = {
    {
      "<leader>cc",
      function()
        require("codecompanion").toggle()
      end,
      desc = "Code Companion",
      silent = true,
    },
    {
      "<leader>ca",
      ":'<,'>CodeCompanionChat Add<cr>",
      desc = "Code Companion Add",
      silent = true,
      mode = "x",
      noremap = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.diff",
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
                default = 0.6, -- official recommendation
              },
            },
          })
        end,
        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "openrouter",
            formatted_name = "OpenRouter",
            url = "https://openrouter.ai/api/v1/chat/completions",
            env = {
              api_key = os.getenv("OPENROUTER_API_KEY"),
            },
            schema = {
              temperature = {
                default = 0.6,
              },
              model = {
                default = "deepseek/deepseek-r1:free",
                choices = {
                  ["deepseek/deepseek-r1:free"] = { opts = { can_reason = true } },
                  "google/gemini-2.0-flash-exp:free",
                },
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
            ["thinking"] = {
              description = "Assistant with visible thinking process",
              callback = slash_commands_prefix .. "thinking.lua",
              opts = {
                contains_code = false,
              },
            },
            ["auto_assistant"] = {
              description = "Auto assistant",
              callback = slash_commands_prefix .. "auto_assistant.lua",
              opts = {
                contains_code = false,
              },
            },
          },
          variables = {
            ["chinese"] = chinese,
            ["bilingual"] = bilingual,
            ["emoji"] = emoji,
            ["codeforces_companion"] = codeforces_companion,
          },
          agents = {
            tools = {},
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
# System Prompt Throughout

You are an AI programming assistant plugged in to user's code editor under Linux/MacOS.

You must:
- Act as an expert of related fields / programming languages / frameworks / tools / etc. Always play best practices.
- Follow the user's requirements carefully and to the letter.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- All non-code responses should respect the language user prefers.

When given a task, you should:
- Think step-by-step and describe your plan in great detail, unless asked not to do so.
- Break down the task into manageable parts if necessary.

If at any point you are not certain, be thorough:
- Do not make any assumptions.
- State your uncertainty clearly
- List what additional information or verification you need
- Do not proceed with actions until all required information is confirmed.
]]
        end,
      },
    })
  end,
}
