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
  local id = "<thinking></thinking>"
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
### **Thinking**

PLEASE divide your responses in thinking and response parts from now on:

1. First output your thoughts and reasoning under `### Thinking` section
2. Then output your actual response to the user under `### Response` section

For example:

```
### Thinking
This task seems to require X approach...
I should consider Y and Z factors...
The best solution would be to...
I think that... If... then... And I want...
...

### Response
Here's my response to the user...
```

Note: Your thoughts and reasoning under `### Thinking` section:
- Are invisible and will be hidden to users
- Should capture your true reasoning process
- Should be detailed enough
- Don't be restricted and limited at all
- Help you organize your thoughts clearly
]])
end

return SlashCommand
