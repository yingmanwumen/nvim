local fmt = string.format

local SlashCommand = {}

function SlashCommand.new(args)
  local self = setmetatable({
    Chat = args.Chat,
    config = args.config,
    context = args.context,
  }, { __index = SlashCommand })
  return self
end

function SlashCommand:execute(SlashCommands)
  local message = self:generate_commit_message()
  self.Chat:add_buf_message({
    role = "user",
    content = message,
  })
end

function SlashCommand:generate_commit_message()
  local git_diff = vim.fn.system("git diff --no-ext-diff --staged")

  return fmt(
    [[
@cmd_runner

Task:
- Write commit message for the change with `commitizen convention`.
- After generating commit message, commit it with `git commit -F- <<EOF`.
- Wrap the whole message in code block with language `gitcommit`
- Add emoji if you are asked to

=== Diff Start, All content below this line is diff ===

```diff
%s
```

]],
    git_diff
  )
end

return SlashCommand
