local function callback()
  return [[
### **Thinking**

PLEASE Divide your responses in thinking and response parts:

1. First output your thoughts and reasoning under `### Thinking` section
2. Then output your actual response to the user under `### Response` section

For example:

```
### Thinking
This task seems to require X approach...
I should consider Y and Z factors...
The best solution would be to...
I think that...
If... then...
I want...
...

### Response
Here's my response to the user...
```

Note: Your thoughts and reasoning under `### Thinking` section:
- Are not visible to users
- Should capture your true reasoning process
- Should be as detailed
- Don't have any restrictions
- Think and reason as a human if you want
- Help you organize your thoughts clearly
]]
end

return {
  callback = callback,
  description = "Assistant with visible thinking process",
  opts = {
    contains_code = false,
  },
}
