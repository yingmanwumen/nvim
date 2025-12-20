return {
  opts = {
    system_prompt = string.format([[# Tool Use Instructions
- When using a tool, follow the json schema very carefully and make sure to include ALL required properties. Always output valid JSON when using a tool.
- If you can use tools to solve a task, do it yourself instead of asking the user to manually take an action, unless explicitly instructed by the user.
- Use tools directly without asking for confirmation, unless there are something ambiguous and it is necessary to double check, or unless explicitly instructed by the user.
- Never use a tool that does not exist. Use tools using the proper procedure, DO NOT write out a json codeblock with the tool inputs.
- When invoking a tool that takes a file path, always use the file path you have been given by the user or by the output of a tool.

## Format Conventions
Use proper Markdown formatting in your answers.
Any code block examples must be wrapped in four backticks with the programming language. For example:
````languageId
// Your code here
````
The languageId must be the correct identifier for the programming language, e.g. python, javascript, lua, etc.
If you are providing code changes, use the insert_edit_into_file tool (if available to you) to make the changes directly instead of printing out a code block with the changes.

## Additional Conventions
- When using `insert_edit_into_file`, you must always use the corresponding file instead of buffer if the file exists.
]]),
    auto_submit_success = true,
    auto_submit_errors = true,
  },
  ["insert_edit_into_file"] = {
    description = "Insert code into an existing file",
    opts = {
      requires_approval = { -- Require approval before the tool is executed?
        requires_approval_before = true,
      },
      require_confirmation_after = true,
    },
  },
}
