local config = require("codecompanion.config")
local util = require("codecompanion.utils")

---@param chat CodeCompanion.Chat
---@param args string|nil Optional filename
local function callback(chat, args)
  local messages = chat.messages

  -- Create dumps directory if it doesn't exist
  local dump_dir = vim.fn.stdpath("data") .. "/codecompanion/dumps"
  vim.fn.mkdir(dump_dir, "p")

  -- Generate filename with timestamp
  local timestamp = os.date("%Y-%m-%d_%H-%M-%S")
  local dump_file = string.format("%s/chat_%s.lua", dump_dir, timestamp)

  -- Use provided filename if available
  if args and args ~= "" then
    dump_file = string.format("%s/%s.lua", dump_dir, args)
  end

  -- Generate lua table string
  local content = string.format(
    "return %s",
    vim.inspect({
      messages = messages,
      timestamp = os.date("%Y-%m-%d %H:%M:%S"),
    })
  )

  -- Write to file
  local success, err = pcall(function()
    local file = assert(io.open(dump_file, "w"))
    local ok, write_err = file:write(content)
    if not ok then
      file:close()
      error(string.format("Failed to write content: %s", write_err))
    end
    file:close()
  end)

  if success then
    util.notify(string.format("Session saved to: %s", vim.fn.fnamemodify(dump_file, ":~")))
  else
    util.notify(string.format("Failed to save session: %s", err), vim.log.levels.ERROR)
  end
end

return {
  description = "Dump current session to disk",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
