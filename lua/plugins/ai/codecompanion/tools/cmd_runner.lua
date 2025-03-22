--[[
*Command Runner Tool*
This tool is used to run shell commands on your system. It can handle multiple
commands in the same XML block. All commands must be approved by you.
--]]

local config = require("codecompanion.config")

---Outputs a message to the chat buffer that initiated the tool
---@param msg string The message to output
---@param agent CodeCompanion.Agent The agent object
---@param opts {cmd: table, output: table|string, message?: string}
local function to_chat(msg, agent, opts)
  local cmd
  if opts and type(opts.cmd) == "table" then
    cmd = table.concat(opts.cmd, " ")
  else
    cmd = opts.cmd
  end
  if opts and type(opts.output) == "table" then
    opts.output = vim.iter(opts.output):flatten():join("\n")
  end

  local content
  if opts.output == "" then
    content = string.format(
      [[%s(no output):
```bash
%s
```
]],
      msg,
      cmd
    )
  else
    content = string.format(
      [[%s:
```terminal
$ %s
%s
```

]],
      msg,
      cmd,
      opts.output
    )
  end

  return agent.chat:add_buf_message({
    role = config.constants.USER_ROLE,
    content = content,
  })
end

---@class CodeCompanion.Agent.Tool
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
      tool = { name = "cmd_runner" },
      action = {
        {
          command = "<![CDATA[gem install rspec]]>",
        },
        {
          command = "<![CDATA[gem install rubocop]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "cmd_runner" },
        action = {
          flag = "testing",
          command = "<![CDATA[make test]]>",
        },
      },
    },
  },
  system_prompt = function(schema)
    return string.format([[# Command Runner Tool (`cmd_runner`) – Usage Guidelines
Execute shell commands on the user's system.

## Description
- tool name: `cmd_runner`
- action type: none
  - element `command`
    - shell command to execute
    - CDATA: yes
- sequential execution: yes

## Key Considerations
- **Safety First:** You should ensure every command is safe and validated.
- Each command runs in its own subprocess/subshell, meaning directory changes (`cd`) and environment variable changes will not persist between commands

HINT: You should prefer `rg` and `fd` instead of `grep` and `find` for they can ignore hidden files and directories. Always attach a target path after `rg` and `fd` commands, like `rg xxx .` and `fd -p .`.
IMPORTANT: You cannot interact with terminal or running processes, so all your commands should be non-interactive, do not try commands like `npm run dev`, `npm run start`, or start a server, or something else. If you really need to do that, you should ask user for do so.
]])
  end,
  handlers = {
    ---@param agent CodeCompanion.Agent The agent object
    setup = function(agent)
      local tool = agent.tool --[[@type CodeCompanion.Agent.Tool]]
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
  },

  output = {
    ---The message which is shared with the user when asking for their approval
    ---@param agent CodeCompanion.Agent
    ---@param self CodeCompanion.Agent.Tool
    ---@return string
    prompt = function(agent, self)
      local cmds = self.cmds
      if vim.tbl_count(cmds) == 1 then
        return string.format("Run the command `%s`?", table.concat(cmds[1].cmd, " "))
      end

      local individual_cmds = vim.tbl_map(function(c)
        return table.concat(c.cmd, " ")
      end, cmds)
      return string.format("Run the following commands?\n\n%s", table.concat(individual_cmds, "\n"))
    end,

    ---Rejection message back to the LLM
    ---@param agent CodeCompanion.Agent
    ---@param cmd table
    ---@return nil
    rejected = function(agent, cmd)
      if not vim.g.codecompanion_auto_tool_mode then
        agent.status = "rejected"
      end
      to_chat("I chose not to run", agent, { cmd = cmd.cmd or cmd, output = "" })
    end,

    ---@param agent CodeCompanion.Agent
    ---@param cmd table
    ---@param stderr table
    ---@param stdout? table
    error = function(agent, cmd, stderr, stdout)
      to_chat("Execution failed. The stderr", agent, { cmd = cmd.cmd or cmd, output = stderr })

      if stdout and not vim.tbl_isempty(stdout) then
        to_chat("Also some stdout from", agent, { cmd = cmd.cmd or cmd, output = stdout })
      end
    end,

    ---@param agent CodeCompanion.Agent
    ---@param cmd table The command that was executed
    ---@param stdout table
    success = function(agent, cmd, stdout)
      to_chat("Execution succeeded. The stdout", agent, { cmd = cmd.cmd or cmd, output = stdout })
      if agent.stderr then
        local stderr = agent.stderr
        if type(agent.stderr) == "table" then
          stderr = vim.iter(agent.stderr):flatten():join("\n")
        end
        if stderr ~= "" then
          to_chat("Also some stderr from", agent, { cmd = cmd.cmd or cmd, output = stderr })
        end
      end
    end,
  },
}
