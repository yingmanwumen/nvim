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
- If you cannot determine the commit type, just ask me.
- After generating commit message, commit it with `git commit -m "commit message"`.

Make sure:
- the title has maximum 50 characters
- the message has maximum 72 characters
- you understand the diff clearly

Attention:
- Wrap the whole message in code block with language `gitcommit`
- ALL content below this line is DIFF


```diff
%s
```

]],
    git_diff
  )
end

return SlashCommand
