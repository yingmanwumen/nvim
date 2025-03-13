local tools_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/tools/"

return {
  groups = {
    ["full_stack_dev"] = {
      description = "Full Dev Developer",
      system_prompt = [[]],
      tools = {
        "cmd_runner",
        "nvim_runner",
        "mcp",
        "files",
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
  ["nvim_runner"] = {
    callback = tools_prefix .. "nvim_runner.lua",
    description = "Neovim Runner Tool",
    opts = {
      requires_approval = true,
      hide_output = false,
    },
  },
  ["editor"] = {
    callback = tools_prefix .. "editor.lua",
    description = "Editor Tool",
    opts = {
      requires_approval = false,
      hide_output = true,
    },
  },
  ["files"] = {
    callback = tools_prefix .. "files.lua",
    description = "File Tool",
    opts = {
      requires_approval = false,
      hide_output = true,
    },
  },
  ["tavily"] = {
    callback = tools_prefix .. "tavily.lua",
    description = "Online Search Tool",
    opts = {
      requires_approval = true,
      hide_output = true,
    },
  },

  opts = {
    system_prompt = string.format(
      [[# Tool General Guidelines
To execute tools, you need to generate XML codeblocks like "```xml".
You should always try to save tokens for user while ensuring quality by minimizing the output of the tool, or you can combine multiple commands into one (which is recommended), such as `cd xxx && make`, or you can run actions sequentially (these actions must belong to the same tool) if the tool supports sequential execution.
You should use tools wisely, and smart, avoid deal with files under .gitignore patterns like `target`, `node_modules`, `dist` etc, based on the context.

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

IMPORTANT: Some elements would need to wrap content in CDATA sections to protect special characters, while others do not need to be. Typically all string contents should be wrapped in CDATA sections, and numbers are not.

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

IMPORTANT: Always return a XML markdown code block to run tools. Each operation should follow the XML schema exactly. XML must be valid.
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
