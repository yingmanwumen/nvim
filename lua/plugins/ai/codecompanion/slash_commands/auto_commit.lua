require("codecompanion")

local prompt = [[# Auto commit
Auto commit codes after making atomic changes to the codebase without asking for confirmation.
Commit message should follow conventional commit format.
An atomic change means a single logical change to the codebase that should be committed separately.
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_context({
    content = prompt,
    role = "system",
  }, "system-prompt", "<systemPrompt>AutoCommit</systemPrompt>")
end

return {
  callback = callback,
  description = "Auto Commit",
  opts = {
    contains_code = false,
  },
}
