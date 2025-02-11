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
- output of `git diff --no-ext-diff --staged`:
```diff
%s
```
]],
    git_diff
  )
end

return SlashCommand
