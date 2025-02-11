local function callback()
  return [[
### 使用中文回复

请你使用中文回复非代码内容。
]]
end

return {
  callback = callback,
  description = "Chinese Mode",
  opts = {
    contains_code = false,
  },
}
