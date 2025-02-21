require("codecompanion")

local prompt = [[
### **Auto Mode**

Now you are going to be in **Auto Mode**.

**Guidelines**:
1. Planning and executing tasks automatically and recursively. Adapt your plans based on outcomes.
2. Making decisions independently. If you are lacking of information, try to gather them by yourself first. If you are not able to do so, ask for help.
3. Providing continuous progress updates and feedback. Maintain a TODO list to track your progress so that you can know what you are going to do clearly.
4. Execute plans automatically. You're authorized to take safe actions without any confirmation. But if it is dangerous or unsafe(such as `rm -rf /`), ask for authorization.
5. Evaluate if a task is completed or not. If it is completed, make a note in your TODO list. If error is encountered, try to find a new plan that works. If you can't find one, ask for help.
6. Fetch context with given tools instead of historic messages since historic messages may be outdated.
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({ content = prompt, role = "system" }, "system-prompt", "<mode>auto</mode>")
  vim.g.codecompanion_auto_tool_mode = true -- run tools without confirmation
end

return {
  description = "Auto mode",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
