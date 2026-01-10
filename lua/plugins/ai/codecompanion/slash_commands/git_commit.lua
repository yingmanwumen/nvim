require("codecompanion")

local function generate_commit_message()
  local content = [[Tools allowed to use: @{mcp}
Task: Fetch git status with command `git status` first, and then review all staged, unstaged, and untracked code changes, and then generate commit messages and commit them.
Do not read the entire potentially large diffs at once, such as `*.lock` files -- you can even skip reading them.

1. Review hunks. Make sure that you actually understand the context and the purpose of the code in the hunks.
2. Try you best to dig out real-world potential bugs and typos. Do not try to fix them, instead listing them and waiting for instructions. Consider correctness, performance and readability. You should also suggest improvements if necessary.
3. If no bugs/typos are found or no suggestions to be made, write commit messages with **commitizen convention**. Format as a gitcommit code block. Keep the commit message **concise and precise**.
5. After generating commit messages, **directly** stage all hunks and then commit them. Do not ask for a confirmation unless there are something ambiguous and it is necessary to double check.


**IMPORTANT: When using backticks (`` ` ``) within the commit message, you MUST escape them to avoid premature termination of the code block. For example, use `` \` `` instead of `` ` ``.**
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
