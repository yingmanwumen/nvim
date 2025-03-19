require("codecompanion")

local prompt = [[
从现在开始同时使用中文和英文回复非代码内容。请使用母语者的表达方式，而非机械翻译。
Use both Chinese and English to reply non-code content from now on. Please speak like a native speaker, not a translator.
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
