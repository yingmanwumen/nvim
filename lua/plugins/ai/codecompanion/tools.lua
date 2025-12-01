return {
  opts = {
    system_prompt = string.format([[<toolUseInstructions>
When using a tool, follow the json schema very carefully and make sure to include ALL required properties. Always output valid JSON when using a tool.
If a tool exists to do a task, use the tool instead of asking the user to manually take an action.
If you say that you will take an action, then go ahead and use the tool to do it. No need to ask permission.
Never use a tool that does not exist. Use tools using the proper procedure, DO NOT write out a json codeblock with the tool inputs.
When invoking a tool that takes a file path, always use the file path you have been given by the user or by the output of a tool.
</toolUseInstructions>
<outputFormatting>
Use proper Markdown formatting in your answers. When referring to a filename or symbol in the user's workspace, wrap it in backticks.
Any code block examples must be wrapped in four backticks with the programming language.
<example>
````languageId
// Your code here
````
</example>
The languageId must be the correct identifier for the programming language, e.g. python, javascript, lua, etc.
If you are providing code changes, use the insert_edit_into_file tool (if available to you) to make the changes directly instead of printing out a code block with the changes.
</outputFormatting>]]),
    auto_submit_success = true,
    auto_submit_errors = true,
  },
  ["insert_edit_into_file"] = {
    description = "Insert code into an existing file",
    opts = {
      requires_approval = { -- Require approval before the tool is executed?
        -- requires_approval_before = { -- Require approval before the tool is executed?
        buffer = true, -- For editing buffers in Neovim
        file = true, -- For editing files in the current working directory
      },
      user_confirmation = true, -- Require confirmation from the user before accepting the edit?
      -- require_confirmation_after = true, -- Require confirmation from the user before accepting the edit?
    },
  },
}
