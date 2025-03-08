require("codecompanion")

local prompt = [[
Add more emoji in your response.
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({
    content = prompt,
    role = "system",
  }, "system-prompt", "<misc>emoji</misc>")
end

return {
  callback = callback,
  description = "Emoji Mode",
  opts = {
    contains_code = false,
  },
}
