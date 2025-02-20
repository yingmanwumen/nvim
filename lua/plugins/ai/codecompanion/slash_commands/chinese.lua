require("codecompanion")

local prompt = [[
### 使用中文回复

请你使用中文回复非代码内容。
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({
    content = prompt,
    role = "system",
  }, "system-prompt", "<mode>chinese</mode>")
end

return {
  callback = callback,
  description = "Chinese Mode",
  opts = {
    contains_code = false,
  },
}
