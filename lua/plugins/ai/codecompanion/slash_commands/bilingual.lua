require("codecompanion")

local prompt = [[
# 双语模式 Bilingual Mode
同时使用中文和英文回复非代码内容。
Use both Chinese and English to reply non-code content.
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({
    content = prompt,
    role = "system",
  }, "system-prompt", "<mode>bilingual</mode>")
end

return {
  callback = callback,
  description = "Bilingual Mode",
  opts = {
    contains_code = false,
  },
}
