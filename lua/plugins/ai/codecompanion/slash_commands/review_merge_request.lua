require("codecompanion")

---@param chat CodeCompanion.Chat
local function callback(chat)
  local content = string.format([[Tools to use: @cmd_runner @files
I need you to review a merge request. Your task:
1. Gather diffs via `git diff <branch_merge_to>...<branch_feature>`
2. Review diffs. Notice that:
   - You should fully understand every piece of code in diffs. You may gather context proactively to understand the diffs.
   - Correctness, performance and readability are the most important factors
   - Also review the design, architecture and implementation
   - Try your best to dig out potential bugs

- Branch merge to: master
- Branch feature: origin/]]) -- wait for manual input

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
