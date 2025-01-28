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
        chat = { adapter = "copilot" },
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
