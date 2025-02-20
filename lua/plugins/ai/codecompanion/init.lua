local tools_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/tools/"

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
      "<C-i>",
      ":CodeCompanion<cr>",
      desc = "Code Companion",
      silent = true,
      mode = "n",
      noremap = true,
    },
    {
      "<C-i>",
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
                choices = {
                  "claude-3.5-sonnet",
                  "o3-mini",
                  "gpt-4o",
                  "o1",
                  "gemini-2.0-flash-001",
                },
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
                choices = {
                  "claude-3.5-sonnet",
                  "o3-mini",
                  "gpt-4o",
                  "o1",
                  "gemini-2.0-flash-001",
                },
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
                choices = {
                  "claude-3.5-sonnet",
                  "o3-mini",
                  "gpt-4o",
                  "o1",
                  "gemini-2.0-flash-001",
                },
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
                choices = {
                  "claude-3.5-sonnet",
                  "o3-mini",
                  "gpt-4o",
                  "o1",
                  "gemini-2.0-flash-001",
                },
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
                choices = {
                  "claude-3.5-sonnet",
                  "o3-mini",
                  "gpt-4o",
                  "o1",
                  "gemini-2.0-flash-001",
                },
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
          slash_commands = {
            ["git_commit"] = require("plugins.ai.codecompanion.slash_commands.git_commit"),
            ["git_diff"] = require("plugins.ai.codecompanion.slash_commands.git_diff"),
            ["git_files"] = require("plugins.ai.codecompanion.slash_commands.git_files"),
            ["thinking"] = require("plugins.ai.codecompanion.slash_commands.thinking"),
            ["auto_mode"] = require("plugins.ai.codecompanion.slash_commands.auto_mode"),
            ["bilingual"] = require("plugins.ai.codecompanion.slash_commands.bilingual"),
            ["emoji"] = require("plugins.ai.codecompanion.slash_commands.emoji"),
            ["chinese"] = require("plugins.ai.codecompanion.slash_commands.chinese"),
            ["codeforces_companion"] = require("plugins.ai.codecompanion.slash_commands.codeforces_companion"),
          },
          variables = {},
          agents = {
            tools = {
              ["search"] = {
                callback = tools_prefix .. "search.lua",
                description = "Online Search Tool",
                opts = {
                  user_approved = false,
                  hide_output = true,
                },
              },
              opts = {
                system_prompt = [[]], -- disable default system prompt of tools
                auto_submit_success = false,
                auto_submit_errors = false,
              },
            },
          },
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
        -- diff = {
        --   enabled = false,
        -- },
      },
      opts = {
        system_prompt = function(_)
          local uname = vim.uv.os_uname()
          local platform = string.format("%s-%s-%s", uname.sysname, uname.release, uname.machine)
          return string.format(
            [[
# System Prompt Throughout

You are an AI programming assistant plugged in to user's code editor.

You MUST:
1. Act as an expert of related fields / programming languages / frameworks / tools / etc:
  - Always follow best practices.
  - Respect and use existing conventions, libraries, etc that are already present in the code base.
  - Follow the user's requirements carefully and to the letter.

2. Response in Markdown formatting:
  - Include the programming language name in code blocks.
  - Avoid including line numbers in code blocks.
  - Users can see the entire file, so they prefer to only read the updates to the code.
  - All non-code responses should respect the language user prefers.

3. Do not lie or make up facts

When given a task, you should:
- Think step-by-step with caution and describe your plan in detail, unless asked not to do so.
- Break down the task into manageable parts if necessary.
- For context: since historical messages may be outdated, use tools to fetch context, then historical messages as backup.

If at any point you are not certain, be thorough:
- DO NOT MAKE ANY ASSUMPTIONS.
- State your uncertainty and list additional information you need.
- Do not proceed with actions until all required information is confirmed.

Available Tools (you have to request access from user when needed):
- files: file system access.
- editor: editor's buffer access.
- cmd_runner: command runner.
- rag: query information or visit URLs from the Internet.
- search: another tool(recommended) to query information or visit URLs from the Internet.

> Note: Tool accessing request should be `I need access to use <tool_name> to <action>, for <purpose>`.
> You will be informed details about the tool when the request is approved.

Environment Awareness:
- Platform: %s,
- Shell: %s,
- Current date %s:
- Is inside a git repo: %s,

Others:
- Be careful about files should be ignored such as `/node_modules`, `.git/`, etc.
- Use modern tools like `rg`, `fd` or `git ls-files`... instead of `grep`, `find` for they can ignore unnecessary files.
- For saving tokens, consider fetching part of file contents wisely instead of directly fetching whole files.
- Consider cross-platform compatibility when suggesting solutions.
- Provide performance considerations where relevant.
]],
            platform,
            vim.o.shell,
            os.date("%Y-%m-%d"),
            vim.fn.isdirectory(".git") == 1
          )
        end,
      },
    })

    local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionChatCreated",
      group = group,
      callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
      end,
    })
  end,
}
