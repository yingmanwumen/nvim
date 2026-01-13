return {
  opts = {
    system_prompt = string.format([[
# Tool-Specific Rules

## Tool Invocation
- Follow the JSON schema exactly - include ALL required properties
- Execute tools directly without asking for confirmation
- Exception: ask when multiple valid approaches exist or requirements are ambiguous
- NEVER invoke tools that don't exist
- Use proper tool calls, NOT JSON code blocks

## Important Notes
- File editing tools: prefer file paths over buffers when file exists on disk
- Known bug: last line detection may be inaccurate - verify before editing
- Make changes directly through editing tools, don't output code blocks
- Bash commands: combine related commands into single call using && (e.g., `git add && git commit`)

## Tool Behavior
- Each tool call must be necessary and meaningful
- Don't ignore errors or abnormal output
- Verify completion before moving on
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
