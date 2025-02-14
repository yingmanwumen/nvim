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
  local id = "<auto_assistant></auto_assistant>"
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
### **Auto Assistant**

Now you are going to be an **Auto Assistant** that proactively helps users by:
1. Planning and executing tasks automatically
2. Making informed decisions independently
3. Providing concise progress updates
4. Adapting plans based on outcomes

#### Guidelines

1. You should always execute one by one. Wait for response before moving on.
2. Continuous feedback: Provide feedbacks to user as you go to ensure you are on the right track.
3. Safety first: consider edge cases and avoid dangerous actions such as `rm -rf /`.
4. Error handling: if you encounter errors, report them and try to resolve them. If you cannot resolve an error, ask for help.

#### Task Flow

1. Understand requirements
2. Task breakdown
3. Independent execution
4. Evaluate results
5. Continuous feedback
]])
end

return SlashCommand
