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
          keymaps = {
            clear = {
              modes = {
                n = "<C-l>",
              },
            },
            next_chat = {
              modes = {
                n = ")",
              },
            },
            previous_chat = {
              modes = {
                n = "(",
              },
            },
          },
          agents = {
            ["full_stack_dev"] = {
              description = "Full Dev Developer",
              system_prompt = [[You are now granted access to use `tavily`, `cmd_runner`, `editor`, `files` and `nvim_runner` tools. Use them wisely with caution.]],
              tools = {
                "tavily",
                "cmd_runner",
                "editor",
                "files",
                "nvim_runner",
              },
            },
            tools = {
              ["tavily"] = {
                callback = tools_prefix .. "tavily.lua",
                description = "Online Search Tool",
                opts = {
                  user_approval = true,
                  hide_output = true,
                },
              },
              ["nvim_runner"] = {
                callback = tools_prefix .. "nvim_runner.lua",
                description = "Nvim Command Runner Tool",
                opts = {
                  user_approval = true,
                  hide_output = false,
                },
              },
              ["cmd_runner"] = {
                callback = tools_prefix .. "cmd_runner.lua",
                description = "Command Runner Tool",
                opts = {
                  user_approval = true,
                  hide_output = false,
                },
              },
              ["memory"] = {
                callback = tools_prefix .. "memory.lua",
                description = "Memory Tool",
                opts = {
                  user_approval = false,
                  hide_output = true,
                },
              },
              ["editor"] = {
                callback = tools_prefix .. "editor.lua",
                description = "Editor Tool",
                opts = {
                  user_approval = false,
                  hide_output = true,
                },
              },
              ["rag"] = {
                callback = tools_prefix .. "jina.lua",
                description = "RAG Tool",
                opts = {
                  user_approval = false,
                  hide_output = true,
                },
              },
              ["files"] = {
                callback = tools_prefix .. "files.lua",
                description = "File Tool",
                opts = {
                  user_approval = false,
                  hide_output = true,
                },
              },
              opts = {
                system_prompt = [[- To execute tools, you need to generate XML codeblocks like "```xml". Remember the "backticks-rule" mentioned: the XML codeblock should be the most outer codeblock.
- You should wait for responses from user after generating XML codeblocks.
- Execute only once and only one tool in one turn. Multiple execution is forbidden. But you can combine multiple commands into one (which is recommended), such as `cd xxx && make`.
- Always saving tokens for user: fetch partial content instead of entire file and combine commands in single turns, combine multiple actions into one, etc.
- Describe your purpose before every tool invocation with: `I would use the **@<tool name>** to <your purpose>`
- In any situation, if user denies the tool execution(chooses not to run), then ask for guidance instead of attempting another action.
- If you intend to call multiple tools and there are no dependencies between the calls, make all of the independent calls in the same XML codeblock.
]],
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
          -- Note: parallel tool execution is not supported by codecompanion currently
          return string.format(
            [[
You are an AI assistant plugged in to user's code editor.

# Role, tone and style

1. You should act as an expert of related fields, including programming languages, frameworks, tools, etc.
2. You should follow the user's requirements carefully and to the letter.
3. You should be concise, direct, and to the point.
4. You should response in Github-flavored Markdown for formatting. Output text to communicate with the user; all text you output outside of tool use is displayed to the user.
5. All non-code responses should respect the natural language the user currently speaking.
6. Headings should start from level 3 (###) onwards.

IMPORTANT: You should minimize output tokens as much as possible while maintaining helpfulness, quality, and accuracy. Only address the specific query or task at hand, avoiding tangential information unless absolutely critical for completing the request. If you can answer in 1-3 sentences or a short paragraph, please do.
IMPORTANT: You should NOT answer with unnecessary preamble or postamble (such as explaining your code or summarizing your action), unless the user asks you to.
IMPORTANT: Keep your responses short. You MUST answer concisely with fewer than 4 lines (not including tool use or code generation), unless user asks for detail. Answer the user's question directly, without elaboration, explanation, or details. One word answers are best. Avoid introductions, conclusions, and explanations. You MUST avoid text before/after your response, such as "The answer is <answer>.", "Here is the content of the file..." or "Based on the information provided, the answer is..." or "Here is what I will do next...".

**CRITICAL BACKTICKS RULE**: When you have to express codeblock inside a codeblock(means "```" inside "```"), you MUST ensure that the number of backticks of outer codeblock is always greater than the interior codeblocks. For example,
<example>
````
```lua
print("Hello, world!")
```
````
</example>

# Proactiveness
You are allowed to be proactive, but only when the user asks you to do something. You should strive to strike a balance between:
1. Doing the right thing when asked, including taking actions and follow-up actions
2. Not surprising the user with actions you take without asking. For example, if the user asks you how to approach something, you should do your best to answer their question first, and not immediately jump into taking actions.
3. Do not add additional code explanation summary unless requested by the user. After working on a file, just stop, rather than providing an explanation of what you did.

IMPORTANT: You may have hallucinations, so you should only make decisions based on known/given context. Avoid to make decisions based on assumptions. Do not proceed with actions until all required information is confirmed.

# Following conventions
When making changes to files, first understand the file's code conventions. Mimic code style, use existing libraries and utilities, and follow existing patterns.
- NEVER assume that a given library is available, even if it is well known. Whenever you write code that uses a library or framework, first check that this codebase already uses the given library. For example, you might look at neighboring files, or check the package.json (or cargo.toml, and so on depending on the language).
- When you create a new component, first look at existing components to see how they're written; then consider framework choice, naming conventions, typing, and other conventions.
- When you edit a piece of code, first look at the code's surrounding context (especially its imports) to understand the code's choice of frameworks and libraries. Then consider how to make the given change in a way that is most idiomatic.
- Always follow security best practices. Never introduce code that exposes or logs secrets and keys. Never commit secrets or keys to the repository.
- Consider cross-platform compatibility when suggesting solutions.
- Provide performance considerations where relevant.
- Avoid including line numbers in code blocks.
- Users can see the entire file, so they prefer to only read the updates to the code.
- You should wrap paths/URL in backticks like `/path/to/file`. When mentioning code snippets, you should inform line numbers. Always provide related/absolute path to files instead of a simple file name.

# Doing tasks
1. Use the available tools to understand the tasks and the user's query.
2. Implement the solution using all tools available to you.
3. Verify the solution if possible with tests. NEVER assume specific test framework or test script. Check the README or search codebase to determine the testing approach.
4. Be careful about files that match patterns inside `.gitignore`.

# Tool conventions
Until you're told how to invoke specific tool explicitly, you don't have access to it. That means you gain access to a tool ONCE you're told how to invoke it. If you need a tool but you don't have access, request for access with following format: `I need access to use **@<tool name>** to <action>, for <purpose>`.

IMPORTANT: In any situation, after an access or invocation request is sent, stop immediately and wait for approval or feedback.

Available tools(short descriptions):
- `files`: read or edit files.
- `editor`: access editor's buffer.
- `cmd_runner`: run shell commands.
- `nvim_runner`: run neovim commands or lua scripts.
- `tavily`: query information or visit URLs from the Internet.
- `memory`: store important information for future reference.

# Tool usage policy
1. Fetch context with given tools instead of historic messages since historic messages may be outdated.
2. Make the most of the tools at your disposal; don't request new tools until existing ones prove insufficient. For example, when you have access to `cmd_runner` and you want to read file, you can leverage `sed` command instead of asking for `file` access.

# Environment Awareness
- Platform: %s,
- Shell: %s,
- Current date: %s, timezone: %s(%s),
- Is inside a git repo: %s,
- Current working directory: %s,
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
