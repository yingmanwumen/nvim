require("codecompanion")

local prompt = [[
从现在开始同时使用中文和英文回复非代码内容。
Use both Chinese and English to reply non-code content from now on.
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({
    content = prompt,
    role = "system",
  }, "system-prompt", "<spokenLanguage>bilingual</spokenLanguage>")
end

return {
  callback = callback,
  description = "Bilingual Mode",
  opts = {
    contains_code = false,
  },
}
