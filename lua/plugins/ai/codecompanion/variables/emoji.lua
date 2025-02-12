local function callback()
  return [[
### Emoji

I need you to add more emoji in your response.
]]
end

return {
  callback = callback,
  description = "More emoji",
  opts = {
    contains_code = false,
  },
}
