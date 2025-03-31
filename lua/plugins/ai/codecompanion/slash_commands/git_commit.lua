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

  local content = [[Tools allowed to use: @cmd_runner @files
- Task:
  1. Before proceeding, review the changes. If there're potential issues or typos, stop and state them. You should fully understand every piece of code in diffs, and analyze the purpose and context of each change.
  2. Write commit messages for the diffs with `commitizen convention`. Format as a gitcommit code block. Keep the commit messages concise and precise. "Concise" means keep the title under 50 characters and wrap message at 72 characters. Remember, you should ensure that each commit is atomic, means each commit only contains ONE logical change, and you should write multiple commits for multiple logical changes.
  3. After generating commit messages, stage diffs and then commit them with `git commit -F- <<EOF`.

Full diffs are as follows:

]]
  if #staged > 0 then
    content = content
      .. "== Staged Changes Start(`git diff --no-ext-diff --staged`) ==\n~~~diff\n"
      .. staged
      .. "\n~~~\n== Staged Changes End(`git diff --no-ext-diff --staged`) ==\n\n"
  end
  if #unstaged > 0 then
    content = content
      .. "== Unstaged Changes Start(`git diff`) ==\n~~~diff\n"
      .. unstaged
      .. "\n~~~\n== Unstaged Changes End(`git diff`) ==\n\n"
  end
  if #untracked > 0 then
    content = content
      .. "== Untracked Files(`git ls-files --others --exclude-standard`) ==\n~~~plaintext\n"
      .. untracked
      .. "\n~~~\n\n"
    local untracked_files = vim.split(untracked, "\n")
    for _, file in ipairs(untracked_files) do
      if file ~= "" then
        local cmd = "git diff --no-index /dev/null " .. file
        local s = vim.fn.system(cmd)
        if s ~= "" then
          content = content .. "== Diff For Untracked File " .. file .. " Start (`" .. cmd .. "`) ==\n~~~diff\n"
          content = content .. s .. "\n~~~\n== Diff For Untracked File " .. file .. " End (`" .. cmd .. "`) ==\n\n"
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
