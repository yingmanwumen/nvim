-- TODO
local prompt = [[
**URL Encoding**
1. Space converts to %20, preserve English double quotes
2. URLs must be single line (no line breaks)
3. Special symbols must be encoded:
   - Plus `+` → `%2B`
   - Parentheses `()` → `%28%29`
   - Angle brackets `<>` → `%3C%3E`
   - Percent sign `%` → `%25`
]]
