local function callback()
  return [[
请您同时使用中文和英文回答问题。
Please answer this question in both Chinese and English.]]
end

return {
  callback = callback,
  description = "Bilingual Mode",
  opts = {
    contains_code = false,
  },
}
