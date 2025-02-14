local function callback()
  return [[
### Emoji

Please add more emoji in your response.
]]
end

return {
  callback = callback,
  description = "More emoji",
  opts = {
    contains_code = false,
  },
}
