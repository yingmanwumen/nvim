local adapter = "copilot_0_3"

local copilot_model_choices = {
  "claude-3.5-sonnet",
  ["claude-3.7-sonnet-thought"] = { opts = { can_reason = true } },
  "claude-3.7-sonnet",
  "o3-mini",
  "gpt-4o",
  "o1",
  "gemini-2.0-flash-001",
}

return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanionChat",
    "CodeCompanion",
    "CodeCompanionCmd",
    "CodeCompanionActions",
  },
  -- version = "v12.15.0",
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
      "<leader>cc",
      ":'<,'>CodeCompanionChat Add<cr>",
      desc = "Code Companion Add",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<C-?>",
      function()
        require("codecompanion").toggle()
      end,
      desc = "Code Companion",
      silent = true,
    },
    {
      "<C-?>",
      ":'<,'>CodeCompanionChat Add<cr>",
      desc = "Code Companion Add",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<leader>ce",
      ":CodeCompanion<cr>",
      desc = "Code Companion",
      silent = true,
      mode = "n",
      noremap = true,
    },
    {
      "<leader>ce",
      ":'<,'>CodeCompanion<cr>",
      desc = "Code Companion",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<C-CR>",
      ":CodeCompanion<cr>",
      desc = "Code Companion",
      silent = true,
      mode = "n",
      noremap = true,
    },
    {
      "<C-CR>",
      ":'<,'>CodeCompanion<cr>",
      desc = "Code Companion",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<leader>ca",
      ":'<,'>CodeCompanionActions<cr>",
      desc = "Code Companion Actions",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<leader>ca",
      ":CodeCompanionActions<cr>",
      desc = "Code Companion Actions",
      silent = true,
      mode = "n",
      noremap = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
    "j-hui/fidget.nvim",
    "echasnovski/mini.diff",
  },
  init = function()
    require("plugins.ai.codecompanion.fidget-spinner"):init()
  end,
  config = function()
    -- Set up function to sync mini.diff highlights with current colorscheme
    local function sync_diff_highlights()
      -- Link the MiniDiff's custom highlights to the default diff highlights
      -- Set highlight color for added lines to match the default DiffAdd highlight
      vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { link = "DiffAdd" })
      -- Set highlight color for deleted lines to match the default DiffDelete highlight
      vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { link = "DiffDelete" })
      -- Set highlight color for changed lines to match the default DiffChange highlight
      vim.api.nvim_set_hl(0, "MiniDiffOverChange", { link = "DiffChange" })
      -- Set highlight color for context lines to match the default DiffText highlight
      vim.api.nvim_set_hl(0, "MiniDiffOverContext", { link = "DiffText" })
    end

    -- Initial highlight setup
    sync_diff_highlights()

    -- Update highlights when colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = sync_diff_highlights,
      group = vim.api.nvim_create_augroup("CodeCompanionDiffHighlights", {}),
    })

    require("codecompanion").setup({
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                choices = {
                  ["gemini-2.0-flash-thinking-exp"] = { opts = { can_reason = true } },
                  "gemini-2.0-flash",
                  "gemini-2.0-pro-exp",
                },
                default = "gemini-2.0-flash-thinking-exp",
              },
            },
          })
        end,
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
                  ["deepseek/deepseek-r1:free"] = { opts = { can_reason = true } }, -- context: 164K
                  ["google/gemini-2.0-flash-exp:free"] = { opts = { can_reason = true } }, -- context: 1.05M
                  ["google/gemini-2.0-pro-exp-02-05:free"] = { opts = { can_reason = true } }, -- context: 2M
                  ["google/gemini-2.0-flash-thinking-exp-1219:free"] = {
                    opts = { can_reason = true },
                  }, -- context: 40K
                  -- Notice: the following models are not for free! Use them with caution.
                  ["anthropic/claude-3.7-sonnet"] = { opts = { can_reason = true } }, -- context: 200K
                },
              },
              num_ctx = {
                default = 200000,
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
                choices = copilot_model_choices,
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
                choices = copilot_model_choices,
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
                choices = copilot_model_choices,
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
                choices = copilot_model_choices,
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
                choices = copilot_model_choices,
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = adapter,
          roles = {
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(llm)
              return llm.formatted_name .. "(" .. llm.schema.model.default .. ")"
            end,
          },
          slash_commands = require("plugins.ai.codecompanion.slash_commands"),
          variables = {},
          keymaps = require("plugins.ai.codecompanion.keymaps"),
          tools = require("plugins.ai.codecompanion.tools"),
        },
        inline = { adapter = adapter },
        agent = { adapter = adapter },
      },
      display = {
        chat = {
          icons = {
            pinned_buffer = "📌 ",
            watched_buffer = "👀 ",
          },
          -- show_settings = true,
          window = {
            position = "right",
          },
        },
        diff = {
          enabled = true,
          close_chat_at = 1,
          provider = "mini_diff",
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
        },
      },
      opts = {
        system_prompt = require("plugins.ai.codecompanion.system_prompt"),
      },
    })

    local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionChatOpened",
      group = group,
      callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
      end,
    })
  end,
}
