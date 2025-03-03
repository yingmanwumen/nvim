require("codecompanion")

local prompt = [[
# Graphviz Tips

When you want to show pictures in graphviz, follow with following rules:

**Code Standards**
1. Attributes must be comma-separated: `[shape=record, label="Data Flow"]`
2. Each statement on a separate line ending with semicolon (including subgraph closure)
3. No unnecessary spaces in Chinese labels
4. Text explanations can supplement the diagram outside the graph

**Error Prevention**
1. Arrows only use `->`
2. Chinese labels must be explicitly declared: `label="User Login"`
3. Node definitions and connections must be written separately, merged writing is forbidden
4. Each statement must end with semicolon (including last line) semicolon must be at statement end, not inside attributes
5. Anonymous nodes are forbidden (must be explicitly named)
6. Chinese labels must not contain spaces
7. Same-named nodes cannot have multiple parents (create duplicate nodes)
8. Node names limited to ASCII characters (use label for Chinese text)
9. Subgraph closure must include semicolon: `subgraph cluster1{...};`
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({
    content = prompt,
    role = "system",
  }, "system-prompt", "<tips>graphviz</tips>")
end

return {
  description = "Generate pictures with graphviz",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
