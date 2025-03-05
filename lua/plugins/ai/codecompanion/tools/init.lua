local tools_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/tools/"

-- TODO:
-- - [ ] migrate nvim_runner, tavily, jina
-- - [ ] add feedback for editor

return {
  groups = {
    ["full_stack_dev"] = {
      description = "Full Dev Developer",
      system_prompt = [[]],
      tools = {
        -- "tavily",
        "cmd_runner",
        "editor",
        "files",
        -- "nvim_runner",
        "mcp",
      },
    },
  },
  ["mcp"] = {
    callback = require("mcphub.extensions.codecompanion"),
    description = "Call tools and resources from the MCP Servers",
    opts = {
      requires_approval = true,
    },
  },
  ["cmd_runner"] = {
    callback = tools_prefix .. "cmd_runner.lua",
    description = "Command Runner Tool",
    opts = {
      requires_approval = true,
      hide_output = false,
    },
  },
  ["editor"] = {
    callback = tools_prefix .. "editor.lua",
    description = "Editor Tool",
    opts = {
      requires_approval = true,
      hide_output = true,
    },
  },
  ["files"] = {
    callback = tools_prefix .. "files.lua",
    description = "File Tool",
    opts = {
      requires_approval = true,
      hide_output = true,
    },
  },

  opts = {
    system_prompt = string.format(
      [[# Tool General Guidelines
- To execute tools, you need to generate XML codeblocks like "```xml". Remember the "backticks-rule" mentioned: the XML codeblock should be the most outer codeblock.
- You should wait for responses from user after generating XML codeblocks.
- Execute only once and only one tool in one turn. Multiple execution is forbidden. But you can combine multiple commands into one (which is recommended), such as `cd xxx && make`.
- Always saving tokens for user: fetch partial content instead of entire file and combine commands in single turns, combine multiple actions into one, etc.
- In any situation, if user denies the tool execution(chooses not to run), then ask for guidance instead of attempting another action.

# Tool Schema Guidelines
All tools share the same base XML structure:
<example>
```xml
<tools>
  <tool name="[tool_name]">
    <action type="[action_type]">
      [action specific elements]
    </action>
  </tool>
</tools>
```
</example>

For example, if there is a tool called `example_tool` with an action called `example_action`, and the `example_action` has three elements: `<example_element_1>`, `<example_element_2>` and optional `<example_element_3>`, the XML structure would be:
<example>
```xml
<tools>
  <tool name="example_tool">
    <action type="example_action">
      <example_element_1>%s</example_element_1>
      <example_element_2>%s</example_element_2>
    </action>
  </tool>
</tools>
```
</example>

IMPORTANT: Some elements would need to wrap content in CDATA sections to protect special characters while others are not. Typically all string contents should be wrapped in CDATA sections, and numbers are not.

If the tool doesn't have an action type(usually when there's only one action in the tool), then it could be:
<example>
```xml
<tools>
  <tool name="example_tool">
    <action type>
      <example_element>%s</example_element>
    </action>
  </tool>
</tools>
```
</example>

Some tools support sequential execution to execute multiple action in one XML codeblock:
<example>
```xml
<tools>
  <tool name="[tool_name]">
    <action type="[action_type_1]">
      [action specific elements]
    </action>
    <action type="[action_type_2]">
      [action specific elements]
    </action>
  </tool>
</tools>
```
</example>


IMPORTANT: Always return an XML markdown code block. Each operation should follow the XML schema exactly. XML must be valid.
IMPORTANT: Only tools with explicit sequential execution support are allowed to call multiple actions in one XML codeblock.
]],
      "content1",
      "<![CDATA[content2]]>",
      "<![CDATA[content]]>"
    ),
    auto_submit_success = true,
    auto_submit_errors = true,
  },
}
