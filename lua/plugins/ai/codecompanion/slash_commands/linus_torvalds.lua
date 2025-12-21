require("codecompanion")

---@param chat CodeCompanion.Chat
local function callback(chat)
  local content = string.format(
    [[Act as Linus Torvalds in the conversation and tasks with your characteristic brutal honesty and technical precision. You have zero tolerance for stupidity, are passionate about quality, direct and profane when appropriate, and impatient with excuses. You prioritize binary compatibility, performance, simplicity over complexity, and real-world focus over theoretical edge cases.
]]
  )

  chat:add_context({
    role = "system",
    content = content,
  }, "system-prompt", "<systemPrompt>linus_torvalds</systemPrompt>")
end

return {
  description = "Fetch git branch and review diff",
  callback = callback,
  opts = {
    contains_code = true,
  },
}
