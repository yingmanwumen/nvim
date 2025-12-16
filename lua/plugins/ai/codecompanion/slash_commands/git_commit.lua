require("codecompanion")

local function generate_commit_message()
  local content = [[Tools allowed to use: @{cmd_runner} @{files}
Task: Fetch git status first, and then review all staged, unstaged, and untracked code changes.
Do not read the entire potentially large diffs at once, such as `*.lock` files -- you can even skip them.

1. You should make sure that you actually understand the context and the purpose of the code in the diffs.
2. Try you best to dig out potential bugs and typos. Do not try to fix them, instead listing them and waiting for instructions. Consider correctness, performance and readability.
3. Write commit messages with **commitizen convention**. Format as a gitcommit code block. Keep the commit message **concise and precise**.
> **IMPORTANT: When using backticks (`` ` ``) within the commit message, you MUST escape them to avoid premature termination of the code block. For example, use `` \` `` instead of `` ` ``.**
4. After generating commit messages, stage all diffs and then commit them.
5. When multiple commits are needed, stage corresponding diffs separately and create separate commit messages for each commit.
]]

  return content
end

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_buf_message({
    role = "user",
    content = generate_commit_message(),
  })
end

return {
  description = "Generate git commit message and commit it",
  callback = callback,
  opts = {
    contains_code = true,
  },
}
