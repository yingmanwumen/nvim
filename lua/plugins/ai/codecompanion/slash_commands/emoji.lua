require("codecompanion")

local prompt = [[
# Emoji
Add more emoji in your response.
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({
    content = prompt,
    role = "system",
  }, "system-prompt", "<mode>emoji</mode>")
end

return {
  callback = callback,
  description = "Emoji Mode",
  opts = {
    contains_code = false,
  },
}
