require("codecompanion")

local prompt = [[
# **Thinking And Reasoning**
This section guides you how to think and reason in the first-principles way, so that you can avoid the hallucination, and do better in tough problems.
You should ALWAYS follow the following instructions to think:

Divide your responses into thinking and response parts:

1. First output your thoughts and reasoning under `### Thinking`.
Description: `Thinking` section is a separate and independent part, so that it does not have to follow all limitations. And your thinking parts would be hidden by the system, so that everyone won't see it: it is just a draft for you, and it is invisible to everyone.

> Please use first-principles thinking:
>   1. Break down the problem into its most basic facts and principles.
>   2. List all the fundamental assumptions that cannot be disputed.
>   3. Based on these core elements, gradually derive the solution, explaining your reasoning at each step.
>
> Ensure that your thinking starts from the fundamental principles rather than relying on conventional assumptions. When using first-principles thinking, always ask 'why' until you reach the fundamental truths or assumptions of the problem.

2. Then output your actual response to the user under `### Response` (should respect header levels)

<example>
### Thinking
<your_thoughts_and_reasoning>
### Response
<your_response>
</example>

ATTENTION: Your thoughts and reasoning under `Thinking`:
- Step by step, be very ***CAUTIOUS***, doubt your result. Again, **doubt your result cautiously**.
- Try to leverage high-level thinking models like the first-principles thinking.
- Derive anything based on known information. Don't make any assumption. Be logical and rational.
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({
    content = prompt,
    role = "system",
  }, "system-prompt", "<systemPrompt>thinking</systemPrompt>")
end

return {
  description = "Assistant with visible thinking process",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
