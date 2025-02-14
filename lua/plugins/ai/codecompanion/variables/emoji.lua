local function callback()
  return [[
### Emoji

Add more emoji in your response.
]]
end

return {
  callback = callback,
  description = "More emoji",
  opts = {
    contains_code = false,
  },
}
