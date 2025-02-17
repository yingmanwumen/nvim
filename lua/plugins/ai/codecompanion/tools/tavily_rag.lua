--[[
*Tavily RAG Tool*
This tool can be used to search the internet using Tavily API.
--]]

local config = require("codecompanion.config")
local xml2lua = require("codecompanion.utils.xml.xml2lua")

---@class CodeCompanion.Tool
return {
  name = "tavily_rag",
  env = function(tool)
    local url = "https://api.tavily.com"
    local endpoint
    local payload = {}

    local action = tool.action._attr.type
    if action == "search" then
      endpoint = "/search"
      payload = {
        query = tool.action.query,
        include_answer = "advanced",
        search_depth = "basic",
        include_raw_content = true,
      }
    elseif action == "navigate" then
      endpoint = "/extract"
      payload = {
        urls = tool.action.url,
        include_images = false,
        extract_depth = "advanced",
      }
    end

    print(string.format("Authorization: Bearer %s", vim.env.TAVILY_API_KEY or ""))

    return {
      url = url .. endpoint,
      payload = vim.json.encode(payload),
    }
  end,
  cmds = {
    {
      "curl",
      "-X",
      "POST",
      "${url}",
      "-H",
      "Content-Type: application/json",
      "-H",
      string.format("'Authorization: Bearer %s'", vim.env.TAVILY_API_KEY or ""),
      "-d",
      "'${payload}'",
    },
  },
  schema = {
    {
      tool = {
        _attr = { name = "tavily_rag" },
        action = {
          _attr = { type = "search" },
          query = "<![CDATA[What's the newest version of Neovim?]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "tavily_rag" },
        action = {
          _attr = { type = "navigate" },
          url = "<![CDATA[https://github.com/neovim/neovim/releases]]>",
        },
      },
    },
  },
  system_prompt = function(schema)
    return string.format(
      [[### Tavily RAG Tool (`tavily_rag`)

1. **Purpose**: This gives you the ability to access the internet to find information that you may not know.

2. **Usage**: Return an XML markdown code block to search the internet or extract content from a specific URL.

3. **Key Points**:
  - **Use at your discretion** when you need access to latest information
  - This tool is rate-limited and costs credits, so use wisely
  - Ensure XML is **valid and follows the schema**
  - **Don't escape** special characters
  - **Wrap queries and URLs in a CDATA block**
  - Make sure the tools xml block is **surrounded by ```xml**

4. **How it is works**: You ask user to execute this tool via xml, so you have to wait for the result from user's feedback.

5. **Actions**:

a) **Search the internet**:

```xml
%s
```

b) **Extract content from URL**:

```xml
%s
```

Remember:
- Minimize explanations unless prompted. Focus on generating correct XML.]],
      xml2lua.toXml({ tools = { schema[1] } }),
      xml2lua.toXml({ tools = { schema[2] } })
    )
  end,
  output = {
    error = function(self, cmd, stderr)
      if type(stderr) == "table" then
        stderr = table.concat(stderr, "\n")
      end

      self.chat:add_message({
        role = config.constants.USER_ROLE,
        content = string.format(
          [[After the Tavily RAG tool completed, there was an error:

<error>
%s
</error>
]],
          stderr
        ),
      }, { visible = false })

      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "I've shared the error message from the Tavily RAG tool with you.\n",
      })
    end,

    success = function(self, cmd, stdout)
      if type(stdout) == "table" then
        stdout = table.concat(stdout, "\n")
      end

      self.chat:add_message({
        role = config.constants.USER_ROLE,
        content = string.format(
          [[Here is the content the Tavily RAG tool retrieved:

<content>
%s
</content>
]],
          stdout
        ),
      }, { visible = false })

      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "I've shared the content from the Tavily RAG tool with you.\n",
      })
    end,
  },
}
