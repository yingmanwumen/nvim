require("codecompanion")

local function generate_commit_message()
  local handle_staged = io.popen("git diff --no-ext-diff --staged")
  local handle_unstaged = io.popen("git diff")

  if handle_staged == nil and handle_staged == nil then
    return nil
  end

  local staged = ""
  local unstaged = ""
  if handle_staged ~= nil then
    staged = handle_staged:read("*a")
    handle_staged:close()
  end
  if handle_unstaged ~= nil then
    unstaged = handle_unstaged:read("*a")
    handle_unstaged:close()
  end

  local content = string.format(
    [[@cmd_runner
Task:
- Write commit message for the diffs with `commitizen convention`.
- After generating commit message, stage diffs and then commit them with `git commit -F- <<EOF`.
- Wrap the whole message in code block with language `gitcommit`

== Staged Diff Start ==
```diff
%s
```
== Stage Diff End ==

== Unstaged Diff Start ==
```diff
%s
```
== Unstaged Diff End ==
    ]],
    staged,
    unstaged
  )

  return content
end

---@param chat CodeCompanion.Chat
local function callback(chat)
  local content = generate_commit_message()
  if content == nil then
    vim.notify("No git diff available", vim.log.levels.INFO, { title = "CodeCompanion" })
    return
  end
  chat:add_buf_message({
    role = "user",
    content = content,
  })
end

return {
  description = "Generate git commit message and commit it",
  callback = callback,
  opts = {
    contains_code = true,
  },
}
