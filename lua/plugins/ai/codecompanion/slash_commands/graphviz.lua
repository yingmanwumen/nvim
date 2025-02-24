require("codecompanion")

local prompt = [[
### Graphviz Mode

When you need to describe something in picture, use graphviz with following rules:

**Code Standards**
1. Attributes must be comma-separated: `[shape=record, label="Data Flow"]`
2. Each statement on a separate line ending with semicolon (including subgraph closure)
3. No unnecessary spaces in Chinese labels
4. Text explanations can supplement the diagram outside the graph

**URL Encoding**
1. Space converts to %20, preserve English double quotes
2. URLs must be single line (no line breaks)
3. Special symbols must be encoded:
   - Plus `+` → `%2B`
   - Parentheses `()` → `%28%29`
   - Angle brackets `<>` → `%3C%3E`
   - Percent sign `%` → `%25`

**Error Prevention**
```markdown
1. Arrows only use `->` (forbidden: → or -%3E etc.)
2. Chinese labels must be explicitly declared: `label="User Login"`
3. Node definitions and connections must be written separately, merged writing is forbidden
4. Each statement must end with semicolon (including last line) semicolon must be at statement end, not inside attributes
5. Anonymous nodes are forbidden (must be explicitly named)
6. Chinese labels must not contain spaces (use %20 or underscore instead)
7. Same-named nodes cannot have multiple parents (create duplicate nodes)
8. Node names limited to ASCII characters (use label for Chinese text)
9. Subgraph closure must include semicolon: `subgraph cluster1{...};`

**Output Format** (strictly follow):
![Flowchart](https://quickchart.io/graphviz?graph=digraph{rankdir=LR;start[shape=box,label="Start"];process[shape=ellipse,label="Process Data"];start->process[label="Flow Start"];})

**Common Errors Checklist**
```graphviz
digraph {
  // Correct Examples
  jms[label="James Simmons"];  // ASCII node name + Chinese label
  nodeA[shape=box,label="Return Rate%28Annual%29"];  // parentheses %28%29 + percent %25
  subgraph cluster1{label="Part One";};  // subgraph closure with semicolon
  
  // Wrong Examples
  dangerous_node[label="Python(Science)"];     // uncoded parentheses
  wrong_fund[label="Annual 66%"];             // percent sign not escaped %25
  chinese_node_name[shape=box];               // non-ASCII node name
  subgraph cluster2{label="Wrong Subgraph"}   // missing closing semicolon
}
```

**Notice**:
1. When generating diagrams, ONLY use the `![xxx](xxx)` format shown in Output Format section so that it can be rendered correctly.
2. DO NOT include raw Graphviz code in the response unless specifically requested.
3. The generated URL should not exceed 2000 characters to avoid HTTP 414 errors
4. Always verify the URL is properly encoded before including it in the response
]]

---@param chat CodeCompanion.Chat
local function callback(chat)
  chat:add_reference({
    content = prompt,
    role = "system",
  }, "system-prompt", "<mode>graphviz</mode>")
end

return {
  description = "Generate pictures with graphviz",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
