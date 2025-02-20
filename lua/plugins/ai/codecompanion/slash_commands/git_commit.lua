require("codecompanion")

local function generate_commit_message()
  local handle_staged = io.popen("git diff --no-ext-diff --staged")
  local handle_unstaged = io.popen("git diff")
  local handle_untracked = io.popen("git ls-files --others --exclude-standard")

  if handle_staged == nil and handle_staged == nil and handle_untracked == nil then
    return nil
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

  local content = [[@cmd_runner
-Task:
-- Write commit message for the diffs with `commitizen convention`.
-- After generating commit message, stage diffs and then commit them with `git commit -F- <<EOF`.
-- Wrap the whole message in code block with language `gitcommit`

### Git Diff

]]
  if #staged > 0 then
    content = content
      .. "== Staged Changes Start(`git diff --no-ext-diff --staged`) ==\n```diff\n"
      .. staged
      .. "\n```\n== Staged Changes End(`git diff --cached`) ==\n\n"
  end
  if #unstaged > 0 then
    content = content
      .. "== Unstaged Changes Start(`git diff`) ==\n```diff\n"
      .. unstaged
      .. "\n```\n== Unstaged Changes End(`git diff --cached`) ==\n\n"
  end
  if #untracked > 0 then
    content = content
      .. "== Untracked Files(`git ls-files --others --exclude-standard`) ==\n```plaintext\n"
      .. untracked
      .. "\n```\n\n"
    local untracked_files = vim.split(untracked, "\n")
    for _, file in ipairs(untracked_files) do
      if file ~= "" then
        local s = vim.fn.system("git diff --no-index /dev/null " .. file)
        if s ~= "" then
          content = content
            .. "== Diff For Untracked File "
            .. file
            .. " Start (`git diff --no-index /dev/null "
            .. file
            .. "`) ==\n```diff\n"
          content = content
            .. s
            .. "\n```\n== Diff For Untracked File "
            .. file
            .. " End (`git diff --no-index /dev/null "
            .. file
            .. "`) ==\n\n"
        end
      end
    end
  end

  return content
end

---@param chat CodeCompanion.Chat
local function callback(chat)
  local content = generate_commit_message()
  if content == nil then
    vim.notify("No git diff available", vim.log.levels.INFO, { title = "CodeCompanion" })
    return
  end
  chat:add_buf_message({
    role = "user",
    content = content,
  })
end

return {
  description = "Generate git commit message and commit it",
  callback = callback,
  opts = {
    contains_code = true,
  },
}
