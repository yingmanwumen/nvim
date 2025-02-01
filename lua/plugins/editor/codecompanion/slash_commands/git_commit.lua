local fmt = string.format

local SlashCommand = {}

-- SlashCommand.new 用来初始化对象
function SlashCommand.new(args)
  local self = setmetatable({
    Chat = args.Chat,
    config = args.config,
    context = args.context,
  }, { __index = SlashCommand })
  return self
end

-- 执行 slash command
function SlashCommand:execute(SlashCommands)
  local message = self:generate_commit_message()
  -- 将生成的 commit message 输出到聊天
  self.Chat:add_buf_message({
    role = "user",
    content = message,
  })
end

-- 生成提交信息模板
function SlashCommand:generate_commit_message()
  local git_diff = vim.fn.system("git diff --no-ext-diff --staged")

  return fmt(
    [[
@cmd_runner

Write commit message for the change with **commitizen convention**.
Make sure:
- the title has maximum 50 characters
- the message is wrapped at 72 characters.

Wrap the whole message in code block with language gitcommit.

After generating commit message, commit it with `git commit -m "<message>"`.

```diff
%s
```

]],
    git_diff
  )
end

return SlashCommand
