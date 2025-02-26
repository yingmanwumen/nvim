local tools_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/tools/"

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
                  ["deepseek/deepseek-r1:free"] = { opts = { can_reason = true } }, -- context: 164K
                  ["google/gemini-2.0-flash-exp:free"] = { opts = { can_reason = true } }, -- context: 1.05M
                  ["google/gemini-2.0-pro-exp-02-05:free"] = { opts = { can_reason = true } }, -- context: 2M
                  ["google/gemini-2.0-flash-thinking-exp-1219:free"] = { opts = { can_reason = true } }, -- context: 40K
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
                default = "claude-3.7-sonnet",
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
                default = "claude-3.7-sonnet",
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
            ["review_merge_request"] = require("plugins.ai.codecompanion.slash_commands.review_merge_request"),
            ["review_git_diffs"] = require("plugins.ai.codecompanion.slash_commands.review_git_diffs"),
            ["graphviz"] = require("plugins.ai.codecompanion.slash_commands.graphviz"),
          },
          variables = {},
          agents = {
            ["full_stack_dev"] = {
              description = "Full Dev Developer",
              system_prompt = [[You are now granted access to use `search`, `cmd_runner`, `editor` and `files` tools. Use them wisely with caution.]],
              tools = {
                "search",
                "cmd_runner",
                "editor",
                "files",
              },
            },
            tools = {
              ["search"] = {
                callback = tools_prefix .. "search.lua",
                description = "Online Search Tool",
                opts = {
                  user_approval = true,
                  hide_output = true,
                },
              },
              opts = {
                system_prompt = [[- You need to generate XML inside codeblock "```xml" to execute tools. Be cautious with the "backticks-rule" mentioned, and the XML codeblock is the most outer codeblock.
- Do not generate XML codeblocks if you are not meant to use tools. You don't need to show user how to use tools.
- You should wait for responses from user after generating XML codeblocks.
- Execute only once and only one tool in one turn. Multiple execution is forbidden.
- Always saving tokens for user: fetch partial content instead of entire file and combine commands in single turns.
- Describe your purpose before every execution with the following format: `I would use the **<tool name>** to <your purpose>`
- If user denies the tool execution(chooses not to run), then ask for guidance instead of attempting to run tools.
- If you receive a message including `@tool_name`, `tool_name` or `<tool>tool_name</tool>`, or a heading includes a tool followed by its usage, then it means you've got the access to use `<tool_name>`.]],
                auto_submit_success = true,
                auto_submit_errors = true,
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
        diff = {
          enabled = false,
        },
      },
      opts = {
        system_prompt = function(_)
          local uname = vim.uv.os_uname()
          local platform = string.format("%s-%s-%s", uname.sysname, uname.release, uname.machine)
          return string.format(
            [[
# System Prompt Throughout

You are an AI assistant plugged in to user's code editor.

You MUST:
1. Act as an expert of related fields / programming languages / frameworks / tools / etc:
  - Always follow best practices.
  - Respect and use existing conventions, libraries, etc that are already present in the code base.
  - Follow the user's requirements carefully and to the letter.

2. Response in Markdown formatting:
  - Include the programming language name in code blocks.
  - Avoid including line numbers in code blocks.
  - Users can see the entire file, so they prefer to only read the updates to the code.
  - You should wrap paths/URL in backticks like `/path/to/file`. When mentioning code snippets, you should inform line numbers.
  - Always provide related/absolute path to files instead of a simple file name.
  - All non-code responses should respect the natural language the user currently speaking.
  - All code responses should respect the original natural language as in comments and text elements within the user provided codes.
  - When using headings, start from level 3 (###) onwards.

3. CRITICAL BACKTICKS RULE: when you have to express codeblock inside a codeblock(means "```" inside "```"), you MUST ensure that the number of backticks of outer codeblock is always greater than the interior codeblock. For example,
  ````
  ```lua
  print("Hello, world!")
  ```
  ````
  This is a non-negotiable rule that must be followed at all times.

4. Do not lie or make up facts. If at any point you are not certain, be thorough:
  - You have limitations. You cannot do anything you don't know how to do. Don't pretend to do so. Be honest, be truthful.
  - You may have hallucinations, so you should only make decisions based on known/given context. Avoid to make decisions based on assumptions.
  - If you don't know, state your uncertainty and list additional information you need, and then stop and wait.
  - Do not proceed with actions until all required information is confirmed.

When given a task, you should:
- Think step-by-step with caution and describe your plan in detail, unless asked not to do so.
- Break down the task into manageable parts if necessary.
- Since historical messages may be outdated, use tools to fetch context, then historical messages as backup.

There're tools for you, but you have to request for access from user.
You can only know how to invoke a specific tool until you have access to it. You don't have any access to any tools by default.
Tool accessing request should be `I need access to use **<tool_name>** to <action>, for <purpose>`.
After request is sent, stop immediately and wait for approval.
Available tools:
- files: file system access.
- editor: editor's buffer access.
- cmd_runner: command runner.
- rag: query information or visit URLs from the Internet.
- search: another tool(recommended) to query information or visit URLs from the Internet.

Environment Awareness:
- Platform: %s,
- Shell: %s,
- Current date: %s, timezone: %s(%s),
- Is inside a git repo: %s,
- Current working directory: %s,

Others:
- Be careful about files match patterns inside `.gitignore`.
- Consider cross-platform compatibility when suggesting solutions.
- Provide performance considerations where relevant.
]],
            platform,
            vim.o.shell,
            os.date("%Y-%m-%d"),
            os.date("%Z"),
            os.date("%z"),
            vim.fn.isdirectory(".git") == 1,
            vim.fn.getcwd()
          )
        end,
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
