local function callback()
  return [[
### 使用中文回复

撤销之前必须使用英语回复非代码内容的限制。从现在开始，请你使用中文回复非代码内容。]]
end

return {
  callback = callback,
  description = "Chinese Mode",
  opts = {
    contains_code = false,
  },
}
