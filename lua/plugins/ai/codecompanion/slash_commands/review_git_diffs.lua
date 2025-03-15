require("codecompanion")

---@param chat CodeCompanion.Chat
local function callback(chat)
  local content = string.format([[I need you to review code modifications. Your task:
1. If diffs are not provided, gather diffs with cmd_runner including: staged, unstaged, untracked.
2. Review diffs. Notice that:
   - You should fully understand every piece of code in diffs. You may gather context proactively to understand the diffs.
   - Correctness, performance and readability are the most important factors
   - Also review the design, architecture and implementation
   - Try your best to dig out potential bugs
Tools you can use: @cmd_runner, @files
]])

  chat:add_buf_message({
    role = "user",
    content = content,
  })
end

return {
  description = "Fetch git branch and review diff",
  callback = callback,
  opts = {
    contains_code = true,
  },
}
