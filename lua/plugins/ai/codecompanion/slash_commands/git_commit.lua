require("codecompanion")

local function generate_commit_message()
  local content = [[Tools allowed to use: @{mcp}
Fetch git status first, and then review code changes. Do not read potentially large diffs directly, such as `*.lock` files.

1. You should make sure that you actually understand the context and the purpose of the code in the diffs.
2. Try you best to dig out potential bugs and typos. Do not try to fix them, instead listing them and waiting for instructions. Consider correctness, performance and readability.
3. Write commit messages with **commitizen convention**. Format as a gitcommit code block. Keep the commit message **concise and precise**.
4. After generating commit messages, stage diffs and then commit them.
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
