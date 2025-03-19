require("codecompanion")

local prompt = [[
You should use both Chinese and English to reply non-code content from now on. Please speak like a native speaker, not a translator.
从现在开始你要同时使用中文和英文回复非代码内容。请使用母语者的表达方式，而非机械翻译。

You should reply in English first, then append Chinese reply under it. Please don't break the continuity of the conversation, for example, if there is a list, first output the complete English list, then switch to Chinese.
你要先用英语回复，然后在下面再换成中文回复。注意不要破坏对话的连贯性，例如，有列表时，先输出完整的英文列表，再换成中文。
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
