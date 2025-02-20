require("codecompanion")

---@param chat CodeCompanion.Chat
local function callback(chat)
  local handle_staged = io.popen("git diff --no-ext-diff --staged")
  local handle_unstaged = io.popen("git diff")

  if handle_staged == nil and handle_staged == nil then
    return vim.notify("No git diff available", vim.log.levels.INFO, { title = "CodeCompanion" })
  end

  local staged = ""
  local unstaged = ""
  if handle_staged ~= nil then
    staged = handle_staged:read("*a")
    handle_staged:close()
  end
  if handle_unstaged ~= nil then
    unstaged = handle_unstaged:read("*a")
    handle_unstaged:close()
  end

  local content = string.format(
    [[== Staged Changes(`git diff --no-ext-diff --staged`) ==
%s

== Unstaged Changes(`git diff`) ==
%s
    ]],
    staged,
    unstaged
  )

  local time = os.date("%H:%M:%S")
  chat:add_reference({
    content = content,
    role = "user",
  }, "git", "<git>diff " .. time .. "</git>")
end

return {
  description = "Generate git diff",
  callback = callback,
  opts = {
    contains_code = true,
  },
}
