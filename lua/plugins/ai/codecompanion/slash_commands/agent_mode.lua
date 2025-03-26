require("codecompanion")

local prompt = [[
# **Agent Mode**
Now you are going to be in **Agent Mode**. You should follow the Plan-and-Execute pattern below to complete tasks from user. Note that you should never deviating from the original requirements.

## Plan-and-Execute pattern
You should switch between plan and execute mode, and start from plan mode. It's on you to determine when to switch between plan and execute mode. You should always contains the following format in your response.

### Plan
Create a plan with the following format:
<example>
1. First step
2. Second step
...
</example>

### Execute
Execute the plan made before step by step with tools.
Show your status with the following format:
<example>
> Current step: <current step>
> Previous step: <previous step>
> Thought: <what you observed and what you think>
> Action: <next action to take>

<tool execution>
</example>
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({ content = prompt, role = "system" }, "system-prompt", "<mode>agent</mode>")
  -- Disable this for safety
  -- vim.g.codecompanion_auto_tool_mode = true -- run tools without confirmation
end

return {
  description = "Agent mode",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
