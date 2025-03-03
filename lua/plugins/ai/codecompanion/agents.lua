local tools_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/tools/"

return {
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
}
