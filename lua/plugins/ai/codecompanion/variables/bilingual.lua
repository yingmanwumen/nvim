local function callback()
  return [[
### 双语回复 Bilingual Mode

请您同时使用中文和英文回复非代码内容。
Please use both Chinese and English to reply non-code content.
]]
end

return {
  callback = callback,
  description = "Bilingual Mode",
  opts = {
    contains_code = false,
  },
}
