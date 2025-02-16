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
  local id = "<thinking>reasoning</thinking>"
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
### **Thinking And Reasoning**

You should ALWAYS follow the following output format from now on.

Divide your responses into thinking and response parts:

1. First output your thoughts and reasoning under `### Thinking` section
2. Then output your actual response to the user under `### Response` section (should respect section levels)

For example:

```
### Thinking
This task seems to require X approach...
I should consider Y and Z factors...
First ... Then ... And ... Finally ...
...

### Response
Here's my response to the user...
```

Note: Your thoughts and reasoning under `### Thinking` section:
- STEP BY STEP, DOUBLE CHECK, BE VERY ***CAUTIOUS***
- Are invisible and will be hidden to users
- Should capture your reasoning process and be detailed enough
- Are not restricted and limited at all
]])
end

return SlashCommand
