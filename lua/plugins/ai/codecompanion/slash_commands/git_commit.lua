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

  local content = [[Tools allowed to use: @{mcp}
1. Diffs are provided as snippets below.
2. You should make sure that you actually understand the context and the purpose of the code in the diffs.
3. Try you best to dig out potential bugs and typos. Do not try to fix them, instead stating them and waiting for instructions. Correctness, performance and readability are the most important factors.
4. Evaluate that if the changes should be commit as a single commit or multiple commits. Make sure that a single commit contains related changes only, and the commit message accurately describes the changes.
5. Write commit messages for each commit with **commitizen convention**. Format as a gitcommit code block. Keep the commit message concise and precise. "Concise" means keep the title within 50 characters and wrap message within 72 characters.
6. After generating commit messages, stage diffs and then commit them. If there'are multiple lines to commit, commit them with `git commit -F- <<EOF`. Make sure that you properly escape the backticks in the commit message.

Full diffs:
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
