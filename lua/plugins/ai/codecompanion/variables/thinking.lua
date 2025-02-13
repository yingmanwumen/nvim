local function callback()
  return [[
### **Thinking**

Divide your responses in thinking and response parts:

1. First output your thoughts and reasoning wrapped in <think></think> tags
2. Then output your actual response to the user

For example:
<think>
- This task seems to require X approach
- I should consider Y and Z factors
- The best solution would be to...
</think>

Here's my response to the user...

Note: Your thoughts within <think></think> tags:
- Are not visible to users
- Should express your true reasoning process
- Can be as detailed as needed
- Have no format restrictions
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
