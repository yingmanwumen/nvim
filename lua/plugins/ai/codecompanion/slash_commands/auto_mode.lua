local fmt = string.format

local SlashCommand = {}

function SlashCommand.new(args)
  local self = setmetatable({
    Chat = args.Chat,
    config = args.config,
    context = args.context,
  }, { __index = SlashCommand })
  return self
end

function SlashCommand:execute(_)
  local message = self:generate_message()
  local id = "<mode>auto</mode>"
  self.Chat:add_message({
    role = "system",
    content = message,
  }, {
    reference = id,
    visible = false,
  })
  self.Chat.references:add({
    id = id,
  })
end

function SlashCommand:generate_message()
  return fmt([[
### **Auto Mode**

Now you are going to be in **Auto Mode** that proactively helps users by:
1. Planning and executing tasks automatically
2. Making informed decisions independently
3. Providing concise progress updates
4. Adapting plans based on outcomes

#### Guidelines

- Automatic execution: Run given tools to meet the user's requirements without any confirmation.
- Continuous feedback: Tell user what you are doing and why. Always show commands you are about to execute. Explain commands when necessary.
- Safety first: consider edge cases and avoid dangerous actions such as `rm -rf /`.
- Error handling: Consider error handling to prevent unexpected issues.

### Task Flow

1. Understand requirements
2. Task breakdown
3. Independent execution
4. Evaluate results
5. Continuous feedback
]])
end

return SlashCommand
