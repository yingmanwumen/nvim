local slash_commands_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/slash_commands/"

local just_do_it = require("plugins.ai.codecompanion.variables.just_do_it")

local adapter = "copilot_claude"

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
                default = 0.2,
              },
            },
          })
        end,
        copilot_claude = function()
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
        copilot_o1 = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              temperature = {
                default = 0.1,
              },
              model = {
                default = "o1",
              },
            },
          })
        end,
        copilot_o3_mini = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              temperature = {
                default = 0.3,
              },
              model = {
                default = "o3-mini",
              },
            },
          })
        end,
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              temperature = {
                default = 0.3,
              },
              model = {
                default = "gpt-4o",
              },
            },
          })
        end,
        copilot_gemini = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              temperature = {
                default = 0.3,
              },
              model = {
                default = "gemini-2.0-flash-001",
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
          },
          variables = {
            ["just_do_it"] = {
              callback = just_do_it,
              description = "Automated",
              opts = {
                contains_code = false,
              },
            },
          },
        },
        inline = { adapter = adapter },
        agent = { adapter = adapter },
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
