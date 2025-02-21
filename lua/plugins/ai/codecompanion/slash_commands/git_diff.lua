require("codecompanion")

---@param chat CodeCompanion.Chat
local function callback(chat)
  local handle_staged = io.popen("git diff --no-ext-diff --staged")
  local handle_unstaged = io.popen("git diff")
  local handle_untracked = io.popen("git ls-files --others --exclude-standard")

  if handle_staged == nil and handle_staged == nil and handle_untracked == nil then
    return vim.notify("No git diff available", vim.log.levels.INFO, { title = "CodeCompanion" })
  end

  local staged = ""
  local unstaged = ""
  local untracked = ""
  if handle_staged ~= nil then
    staged = handle_staged:read("*a")
    handle_staged:close()
  end
  if handle_unstaged ~= nil then
    unstaged = handle_unstaged:read("*a")
    handle_unstaged:close()
  end
  if handle_untracked ~= nil then
    untracked = handle_untracked:read("*a")
    handle_untracked:close()
  end

  local content = "### Git Diff\n\n"
  if #staged > 0 then
    content = content
      .. "== Staged Changes Start(`git diff --no-ext-diff --staged`) ==\n```diff\n"
      .. staged
      .. "\n```\n== Staged Changes End(`git diff --no-ext-diff --staged`) ==\n\n"
  end
  if #unstaged > 0 then
    content = content
      .. "== Unstaged Changes Start(`git diff`) ==\n```diff\n"
      .. unstaged
      .. "\n```\n== Unstaged Changes End(`git diff`) ==\n\n"
  end
  if #untracked > 0 then
    content = content
      .. "== Untracked Files(`git ls-files --others --exclude-standard`) ==\n```plaintext\n"
      .. untracked
      .. "\n```\n\n"
    local untracked_files = vim.split(untracked, "\n")
    for _, file in ipairs(untracked_files) do
      if file ~= "" then
        local cmd = "git diff --no-index /dev/null " .. file
        local s = vim.fn.system(cmd)
        if s ~= "" then
          content = content .. "== Diff For Untracked File " .. file .. " Start (`" .. cmd .. "`) ==\n```diff\n"
          content = content .. s .. "\n```\n== Diff For Untracked File " .. file .. " End (`" .. cmd .. "`) ==\n\n"
        end
      end
    end
  end

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
