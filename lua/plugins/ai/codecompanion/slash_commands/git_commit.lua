require("codecompanion")

local function generate_commit_message()
  local content = [[Tools allowed to use: @{mcp}
Fetch code changes first.
1. You should make sure that you actually understand the context and the purpose of the code in the diffs.
2. Try you best to dig out potential bugs and typos. Do not try to fix them, instead stating them and waiting for instructions. Correctness, performance and readability are the most important factors.
3. Write commit messages with **commitizen convention**. Format as a gitcommit code block. Keep the commit message **concise and precise**.
4. After generating commit messages, stage diffs and then commit them.

ATTENTION: Make sure that you properly escape the **backticks** in the commit message when committing.
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
