--[[
*Command Runner Tool*
This tool is used to run shell commands on your system. It can handle multiple
commands in the same XML block. All commands must be approved by you.
--]]

local config = require("codecompanion.config")

local util = require("codecompanion.utils")
local xml2lua = require("codecompanion.utils.xml.xml2lua")

---@class CmdRunner.ChatOpts
---@field cmd table|string The command that was executed
---@field output table|string The output of the command
---@field message? string An optional message

---Outputs a message to the chat buffer that initiated the tool
---@param msg string The message to output
---@param tool CodeCompanion.Tools The tools object
---@param opts CmdRunner.ChatOpts
local function to_chat(msg, tool, opts)
  if type(opts.cmd) == "table" then
    opts.cmd = table.concat(opts.cmd, " ")
  end
  if type(opts.output) == "table" then
    opts.output = table.concat(opts.output, "\n")
  end

  local content
  if opts.output == "" then
    content = string.format(
      [[
%s:
~~~bash
%s
~~~
]],
      msg,
      opts.cmd
    )
  else
    content = string.format(
      [[
%s:
~~~terminal
$ %s

%s
~~~
]],
      msg,
      opts.cmd,
      opts.output
    )
  end

  return tool.chat:add_buf_message({
    role = config.constants.USER_ROLE,
    content = content,
  })
end

-- Helper function to determine high-risk shell commands
---@param cmd table|string
---@return boolean
local function is_high_risk(cmd)
  local cmd_str = type(cmd) == "table" and table.concat(cmd.cmd or cmd, " ") or tostring(cmd)

  -- Check for dangerous system commands
  if cmd_str:match("rm%s+%-") or cmd_str:match("rm%s+.*%-rf") then
    -- File removal with switches
    return true
  end

  -- Check for system modification commands
  if
    cmd_str:match("^sudo%s") -- sudo command
    or cmd_str:match("apt%s") -- apt package manager
    or cmd_str:match("yum%s") -- yum package manager
    or cmd_str:match("pacman%s") -- pacman package manager
    or cmd_str:match("dnf%s")
  then -- dnf package manager
    return true
  end

  -- Check for file permission or ownership changes
  if cmd_str:match("chmod%s") or cmd_str:match("chown%s") then
    return true
  end

  -- Check for process termination
  if cmd_str:match("kill%s") or cmd_str:match("killall%s") then
    return true
  end

  -- Check for potentially dangerous curl/wget usage
  if
    (cmd_str:match("curl%s") or cmd_str:match("wget%s"))
    and (cmd_str:match("%-d%s") or cmd_str:match("--data%s") or cmd_str:match("POST"))
  then
    return true
  end

  -- Check for pipes to dangerous commands
  if
    cmd_str:match("|%s*rm%s")
    or cmd_str:match("|%s*chmod%s")
    or cmd_str:match("|%s*sudo%s")
    or cmd_str:match("|%s*xargs%s+rm")
  then
    return true
  end

  -- Check for redirects that might overwrite important files
  if cmd_str:match(">%s*/etc/") or cmd_str:match(">%s*/usr/") then
    return true
  end

  return false
end

---@class CodeCompanion.Tool
return {
  name = "cmd_runner",
  cmds = {
    -- Dynamically populate this table via the setup function
  },
  schema = {
    {
      tool = {
        _attr = { name = "cmd_runner" },
        action = {
          command = "<![CDATA[gem install rspec]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "cmd_runner" },
        action = {
          {
            command = "<![CDATA[gem install rspec]]>",
          },
          {
            command = "<![CDATA[gem install rubocop]]>",
          },
        },
      },
    },
  },
  system_prompt = function(schema)
    return string.format(
      [[# Command Runner Tool (`cmd_runner`) – Usage Guidelines
Execute shell commands on the user's system.

## Description
- tool name: `cmd_runner`
- action type: none
  - element `command`
    - shell command to execute
    - CDATA: yes
- sequential execution: yes

## Key Considerations
- **Safety First:** Ensure every command is safe and validated.
- **User Environment Awareness:**
  - **Neovim Version**: %s
- **User Oversight:** The user retains full control with an approval mechanism before execution.
- **Extensibility:** If environment details aren't available (e.g., language version details), output the command first along with a request for more information.

## Reminder
- Minimize explanations and focus on returning precise XML blocks with CDATA-wrapped commands.
- Each command runs in its own subprocess/subshell, meaning directory changes (`cd`) and environment variable changes will not persist between commands]],
      vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
    )
    --     return string.format(
    --       [[# Command Runner Tool (`cmd_runner`) – Usage Guidelines
    -- Execute safe, validated shell commands on the user's system when explicitly requested.
    --
    -- ## Execution Format:
    -- - Always return an XML markdown code block.
    -- - Each shell command execution should:
    --   - Be wrapped in a CDATA section to protect special characters.
    --   - Follow the XML schema exactly.
    -- - If several commands need to run sequentially, combine them in one XML block with separate <action> entries.
    --
    -- ## XML Schema:
    -- - The XML must be valid. Each tool invocation should adhere to this structure:
    --
    -- ```xml
    -- %s
    -- ```
    --
    -- - Combine multiple shell commands in one response if needed and they will be executed sequentially:
    --
    -- ```xml
    -- %s
    -- ```
    --
    -- ## Key Considerations
    -- - **Safety First:** Ensure every command is safe and validated.
    -- - **User Environment Awareness:**
    --   - **Neovim Version**: %s
    -- - **User Oversight:** The user retains full control with an approval mechanism before execution.
    -- - **Extensibility:** If environment details aren't available (e.g., language version details), output the command first along with a request for more information.
    --
    -- ## Reminder
    -- - Minimize explanations and focus on returning precise XML blocks with CDATA-wrapped commands.
    -- - Each command runs in its own subprocess/subshell, meaning directory changes (`cd`) and environment variable changes will not persist between commands
    -- - Follow this structure each time to ensure consistency and reliability.]],
    --       xml2lua.toXml({ tools = { schema[1] } }), -- Regular
    --       xml2lua.toXml({ tools = { schema[2] } }), -- Sequential
    --       vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
    --     )
  end,
  handlers = {
    ---@param self CodeCompanion.Tools The tool object
    setup = function(self)
      local tool = self.tool --[[@type CodeCompanion.Tool]]
      local action = tool.request.action
      local actions = vim.isarray(action) and action or { action }

      for _, act in ipairs(actions) do
        local entry = { cmd = vim.split(act.command, " ") }
        if act.flag then
          entry.flag = act.flag
        end
        table.insert(tool.cmds, entry)
      end
    end,

    ---Approve the command to be run
    ---@param self CodeCompanion.Tools The tool object
    ---@param cmd table
    ---@return boolean
    approved = function(self, cmd)
      if vim.g.codecompanion_auto_tool_mode then
        return true
      end

      local cmd_concat = table.concat(cmd.cmd or cmd, " ")

      -- Check for high-risk operations and add warning if needed
      local msg = "Run command: `" .. cmd_concat .. "`?"
      if is_high_risk(cmd) then
        msg = "⚠️ HIGH RISK OPERATION! " .. msg
      end

      local ok, choice = pcall(vim.fn.confirm, msg, "No\nYes")
      if not ok or choice ~= 2 then
        return false
      end

      return true
    end,
  },

  output = {
    ---Rejection message back to the LLM
    rejected = function(self, cmd)
      to_chat("I chose not to run", self, { cmd = cmd.cmd or cmd, output = "" })
    end,

    ---@param self CodeCompanion.Tools The tools object
    ---@param cmd table|string The command that was executed
    ---@param stderr table|string
    error = function(self, cmd, stderr)
      local msg = "Stderr from command"
      if stderr == "" then
        msg = "Command completed but with no output(stderr)"
      end
      to_chat(msg, self, { cmd = cmd.cmd or cmd, output = stderr })
    end,

    ---@param self CodeCompanion.Tools The tools object
    ---@param cmd table|string The command that was executed
    ---@param stdout table|string
    success = function(self, cmd, stdout)
      local msg = "Stdout from command"
      if stdout == "" then
        msg = "Command completed but with no output(stdout)"
      end
      to_chat(msg, self, { cmd = cmd.cmd or cmd, output = stdout })
    end,
  },
}
