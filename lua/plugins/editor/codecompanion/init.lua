local slash_commands_prefix = vim.fn.stdpath("config") .. "/lua/plugins/editor/codecompanion/slash_commands/"

local just_do_it = require("plugins.editor.codecompanion.variables.just_do_it")

local adapter = "copilot"
-- local adapter = "deepseek"

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
        -- deepseek = function()
        --   return require("codecompanion.adapters").extend("openai_compatible", {
        --     env = {
        --       url = "https://api.deepseek.com",
        --       api_key = os.getenv("DEEPSEEK_API_KEY"),
        --     },
        --     schema = {
        --       model = {
        --         default = "deepseek-chat",
        --       },
        --       temperature = {
        --         default = 0.5,
        --       },
        --     },
        --   })
        -- end,
        deepseek = function()
          return require("codecompanion.adapters").extend("deepseek", {
            env = {
              -- url = "https://api.deepseek.com",
              api_key = os.getenv("DEEPSEEK_API_KEY"),
            },
            schema = {
              model = {
                default = "deepseek-chat",
              },
              temperature = {
                default = 0.5,
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
