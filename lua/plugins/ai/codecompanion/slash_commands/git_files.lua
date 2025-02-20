require("codecompanion")

---@param chat CodeCompanion.Chat
local function callback(chat)
  local handle = io.popen("git ls-files")
  if handle ~= nil then
    local result = handle:read("*a")
    handle:close()
    local content = string.format(
      [[- Output of `git ls-files`:
```plaintext
%s
```
    ]],
      result
    )

    local time = os.date("%H:%M:%S")
    chat:add_reference({
      content = content,
      role = "user",
    }, "git", "<git>files " .. time .. "<git>")
  else
    return vim.notify("No git files available", vim.log.levels.INFO, { title = "CodeCompanion" })
  end
end
return {
  description = "List git files",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
