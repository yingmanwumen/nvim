--[[
* Tavily Tool*
This tool can be used to search the internet using Tavily API.
--]]

local config = require("codecompanion.config")
local xml2lua = require("codecompanion.utils.xml.xml2lua")
local tool_name = "tavily"
local ACTION_SEARCH = "search"
local ACTION_NAVIGATE = "navigate"

---@class CodeCompanion.Tool
return {
  name = tool_name,
  env = function(tool)
    local url = "https://api.tavily.com"
    local endpoint
    local payload = {}

    local action = tool.action._attr.type
    if action == ACTION_SEARCH then
      endpoint = "/search"
      payload = {
        query = tool.action.query,
        include_answer = "advanced",
        search_depth = "basic",
        include_raw_content = false,
      }
    elseif action == ACTION_NAVIGATE then
      endpoint = "/extract"
      payload = {
        urls = tool.action.url,
        include_images = false,
        extract_depth = "advanced",
      }
    end

    return {
      url = url .. endpoint,
      payload = vim.json.encode(payload),
    }
  end,
  cmds = {
    {
      "curl",
      "-sS",
      "-f",
      "-X",
      "POST",
      "${url}",
      "-H",
      "'Content-Type: application/json'",
      "-H",
      string.format("'Authorization: Bearer %s'", vim.env.TAVILY_API_KEY or ""),
      "-d",
      "'${payload}'",
    },
  },
  schema = {
    {
      tool = {
        _attr = { name = tool_name },
        action = {
          _attr = { type = ACTION_SEARCH },
          query = "<![CDATA[What's the newest version of Neovim?]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = tool_name },
        action = {
          _attr = { type = ACTION_NAVIGATE },
          url = "<![CDATA[https://github.com/neovim/neovim/releases]]>",
        },
      },
    },
  },
  system_prompt = function(schema)
    return string.format(
      [[### Tavily Tool(`tavily`)

1. **Purpose**: Give you the ability to access the Internet.

2. **Usage**: Return an XML markdown code block to search the Internet or extract content from a specific URL.

3. **Key Points**:
  - Use it when you need access to latest information
  - Use wisely
  - Ensure XML is **valid and follows the schema**
  - **Wrap queries and URLs in a CDATA block**
  - Make sure the tools xml block is **surrounded by ```xml**

4. **How it is works**: You ask user to execute this tool via xml, so you have to wait for the result from user's feedback.

5. **Reference Source**: When generating responses based on the Internet sources, you should add references to them.

6. **Actions**:

a) **Search the internet**:

```xml
%s
```

b) **Extract content from URL**:

```xml
%s
```
]],
      xml2lua.toXml({ tools = { schema[1] } }),
      xml2lua.toXml({ tools = { schema[2] } })
    )
  end,
  handlers = {
    ---Approve the command to be run
    ---@param self CodeCompanion.Tools The tool object
    ---@param action table
    ---@return boolean
    approved = function(self, action)
      if vim.g.codecompanion_auto_tool_mode then
        return true
      end

      local prompt = string.format("Allow to search/navigate")
      local ok, choice = pcall(vim.fn.confirm, prompt, "No\nYes")
      if not ok or choice ~= 2 then
        return false
      end
      return true
    end,
  },
  output = {
    error = function(self, _, stderr)
      if type(stderr) == "table" then
        stderr = table.concat(stderr, "\n")
      end

      self.chat:add_message({
        role = config.constants.USER_ROLE,
        content = string.format(
          [[After the Search tool completed, there was some content from `stderr`:

<error>
%s
</error>
]],
          stderr
        ),
      }, { visible = false })

      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "I've shared the `stderr` content from the Search tool with you.\n",
      })
    end,

    success = function(self, _, stdout)
      if type(stdout) == "table" then
        stdout = table.concat(stdout, "\n")
      end

      self.chat:add_message({
        role = config.constants.USER_ROLE,
        content = string.format(
          [[Here is the content the Search tool retrieved:

<content>
%s
</content>
]],
          stdout
        ),
      }, { visible = false })

      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "I've shared the content from the Search tool with you.\n",
      })
    end,
    rejected = function(self, _)
      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = string.format("I reject to to action of search/navigate\n"),
      })
    end,
  },
}
