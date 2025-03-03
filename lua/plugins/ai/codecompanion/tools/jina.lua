--[[
*RAG Tool*
This tool can be used to search the internet or navigate directly to a specific URL.
--]]

local config = require("codecompanion.config")
local xml2lua = require("codecompanion.utils.xml.xml2lua")

---@class CodeCompanion.Tool
return {
  name = "rag",
  env = function(tool)
    local url
    local key
    local value

    local action = tool.action._attr.type
    if action == "search" then
      url = "https://s.jina.ai"
      key = "q"
      value = tool.action.query
    elseif action == "navigate" then
      url = "https://r.jina.ai"
      key = "url"
      value = tool.action.url
    end

    return {
      url = url,
      key = key,
      value = value,
    }
  end,
  cmds = {
    {
      "curl",
      "-sS",
      "-f",
      "-X",
      "POST",
      "${url}/",
      "-H",
      "'Content-Type: application/json'",
      "-H",
      "'X-Return-Format: text'",
      "-d",
      [['{"${key}": "${value}"}']],
    },
  },
  schema = {
    {
      tool = {
        _attr = { name = "rag" },
        action = {
          _attr = { type = "search" },
          query = "<![CDATA[What's the newest version of Neovim?]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "rag" },
        action = {
          _attr = { type = "navigate" },
          url = "<![CDATA[https://github.com/neovim/neovim/releases]]>",
        },
      },
    },
  },
  system_prompt = function(schema)
    return string.format([[# Retrieval Augmented Generated (RAG) Tool (`rag`)
Gain the ability to access the Internet.

Reference Source: When generating responses based on the Internet sources, you should add references to them.

**How it is works**: You ask user to execute this tool via xml, so you have to wait for the result from user's feedback.

Usage: Return an XML markdown code block to search the Internet or extract content from a specific URL. Use it when you need access to latest information. Use it wisely.

## Description
- tool name: `rag`
- sequential execution: no
- action type: `search`
  - element `query`
    - the search query.
    - CDATA: yes
- action type: `navigate`
  - element `url`
    - the target URL.
    - CDATA: yes
]])

    --     return string.format(
    --       [[# Retrieval Augmented Generated (RAG) Tool (`rag`)
    -- Gain the ability to access the Internet.
    --
    -- Reference Source: When generating responses based on the Internet sources, you should add references to them.
    --
    -- **How it is works**: You ask user to execute this tool via xml, so you have to wait for the result from user's feedback.
    --
    -- Usage: Return an XML markdown code block to search the Internet or extract content from a specific URL.
    --
    -- ## Key Points
    -- - Use it when you need access to latest information. Use it wisely.
    -- - Ensure XML is **valid and follows the schema**
    -- - **Wrap queries and URLs in a CDATA block**
    -- - Make sure the tools xml block is **surrounded by ```xml**
    --
    -- ## XML Format
    --
    -- a) **Search the internet**:
    --
    -- ```xml
    -- %s
    -- ```
    --
    -- b) **Navigate to a URL**:
    --
    -- ```xml
    -- %s
    -- ```
    -- ]],
    --       xml2lua.toXml({ tools = { schema[1] } }),
    --       xml2lua.toXml({ tools = { schema[2] } })
    --     )
  end,
  output = {
    error = function(self, cmd, stderr)
      if type(stderr) == "table" then
        stderr = table.concat(stderr, "\n")
      end

      self.chat:add_message({
        role = config.constants.USER_ROLE,
        content = string.format(
          [[After the RAG tool completed, there was an error:

<error>
%s
</error>
]],
          stderr
        ),
      }, { visible = false })

      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "I've shared the error message from the RAG tool with you.\n",
      })
    end,

    success = function(self, cmd, stdout)
      if type(stdout) == "table" then
        stdout = table.concat(stdout, "\n")
      end

      self.chat:add_message({
        role = config.constants.USER_ROLE,
        content = string.format(
          [[Here is the content the RAG tool retrieved:

<content>
%s
</content>
]],
          stdout
        ),
      }, { visible = false })

      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "I've shared the content from the RAG tool with you.\n",
      })
    end,
  },
}
