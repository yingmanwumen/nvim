--[[
* Tavily Tool*
This tool can be used to search the internet using Tavily API.
--]]

local config = require("codecompanion.config")
local tool_name = "tavily"
local ACTION_SEARCH = "search"
local ACTION_NAVIGATE = "navigate"

---Outputs a message to the chat buffer that initiated the tool
---@param msg string The message to output
---@param tool CodeCompanion.Agent The tools object
---@param opts {output: table|string, message?: string}
local function to_chat(msg, tool, opts)
  if opts and type(opts.output) == "table" then
    opts.output = vim.iter(opts.output):flatten():join("\n")
  end

  local content
  if opts.output ~= "" then
    content = string.format(
      [[%s:
<content>
%s
</content>
]],
      msg,
      opts.output
    )
    tool.chat:add_message({
      role = config.constants.USER_ROLE,
      content = content,
    }, { visible = false })
  end

  tool.chat:add_buf_message({
    role = config.constants.USER_ROLE,
    content = "I've shared the result from the Search tool with you.\n",
  })
end

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
    return string.format([[# Tavily Tool(`tavily`) -- Usage Guidelines
Gain the ability to access the Internet.

Source Citation: When referencing information from the Internet, add footnote citations with source URLs at the bottom of your response.

**How it is works**: You ask user to execute this tool via xml, so you have to wait for the result from user's feedback.

Usage: Return an XML markdown code block to search the Internet or extract content from a specific URL. Use it when you need access to latest information. Use it wisely.

## Description
- tool name: `tavily`
- sequential execution: no
- action type: `search`
  - element `query`
    - the search query.
    - CDATA: yes
- action type: `navigate`
  - element `url`
    - target URL to extract content from.
    - CDATA: yes

## Search Policy
1. Before searching (not navigating), analyse your/user's requirements first, and then generate effective queries
2. Conduct follow-up searches and navigate through results as needed to gather complete information, and then generate the final result
    ]])
  end,
  handlers = {},
  output = {
    ---@param agent CodeCompanion.Agent The tool object
    ---@param self CodeCompanion.Agent.Tool
    prompt = function(agent, self)
      return ("Allow to " .. self.request.action._attr.type .. "?: '")
        .. (self.request.action.query and self.request.action.query or self.request.action.url)
        .. "'"
    end,

    ---@param agent CodeCompanion.Agent
    ---@param cmd table
    ---@param stderr table
    ---@param stdout? table
    error = function(agent, cmd, stderr, stdout)
      to_chat("Execution failed. stderr from Search tool", agent, { output = stderr })
      if stdout and not vim.tbl_isempty(stdout) then
        to_chat("Also some content from Search tool retrieved", agent, { cmd = cmd.cmd or cmd, output = stdout })
      end
    end,

    success = function(agent, _, stdout)
      to_chat("Execution succeeded. Here is the content from Search tool retrieved", agent, { output = stdout })
    end,

    rejected = function(self, _)
      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = string.format("I reject to to action of search/navigate\n"),
      })
    end,
  },
}
