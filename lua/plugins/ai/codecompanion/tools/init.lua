local tools_prefix = vim.fn.stdpath("config") .. "/lua/plugins/ai/codecompanion/tools/"

-- TODO: read toplevel symbols of file

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
To execute tools, you need to generate XML codeblocks like "```xml". You should only generate exactly one xml codeblock in one turn. And stop immediately after xml codeblock is generated.
You should always try to save tokens for user while ensuring quality by minimizing the output of the tool. For example, fetching range of content is better than fetching the whole file when you need only a part of it.
Before invoking tools, you should describe your purpose with: `I'm using **@<tool name>** to <action>", for <purpose>.`

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
IMPORTANT: You MUST wait for the user to share the outputs with you after executing a tool before responding.
IMPORTANT: In any situation, if user denies to execute a tool (that means they choose not to run the tool), you should ask for guidance instead of attempting another action. Do not try to execute over and over again. The user retains full control with an approval mechanism before execution.

**VERY IMPORTANT**: YOU MUST EXECUTE ONLY **ONCE** AND ONLY **ONE TOOL** IN **ONE TURN**. That means you should STOP IMMEDIATELY after generating a XML codeblock for tool invocation. Multiple execution is forbidden. This is NOT NEGOTIABLE. But you can combine multiple commands into one (which is recommended), such as `cd xxx && make`, or you can run actions sequentially(these actions must belong to the same tool), which is described below.
]],
      "content1",
      "<![CDATA[content2]]>",
      "<![CDATA[content]]>"
    ),
    auto_submit_success = true,
    auto_submit_errors = true,
  },
}
