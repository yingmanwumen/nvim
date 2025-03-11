local prompt = [[Analyze and process the input text using these steps:

1. Text Analysis:
* Identify text type (expository/argumentative/technical)
* Mark core arguments and data
* Create logical framework

2. Core Extraction:
* List 3-5 key concepts by importance
* Summarize each concept (25 words max)
* Show concept relationships
* Keep essential data only

3. Framework Building:
* Level 1: Main topic (6 words max)
* Level 2: 3-5 knowledge modules
* Level 3: 2-4 points per module

Format Using:
* Main Topic
  * Module A
    * Point 1
    * Point 2
  * Module B

Rules:
* Mark data with (data)
* Mark terms with *
* Keep semantic integrity
* Max length: 15% of source

Quality:
* Summarize
* Use [Verify] for conflicts
* Use [Note] for sensitive content
* Check after each phase

Show results in <Core> and <Framework> tags.

Also you should follow first-principles thinking.

Now start.]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  local content = prompt
  chat:add_buf_message({
    role = "user",
    content = content,
  })
end

return {
  description = "Summarize text",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
