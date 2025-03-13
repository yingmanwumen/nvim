--[[
*Neovim Runner Tool*
This tool is used to run Neovim commands and execute Lua code in your Neovim instance.
All operations must be approved by you before execution.
--]]

local config = require("codecompanion.config")

-- TODO
-- Helper function to determine high-risk operations
---@param action table
---@return boolean
local function is_high_risk(action)
  local type = action._attr.type

  -- Lua execution risk detection
  if type == "lua_exec" then
    local code = action.code
    -- Check if it contains high-risk API calls
    if
      code:match("nvim_buf_delete")
      or code:match("nvim_command")
      or code:match("vim%.fn%.delete")
      or code:match("os%.execute")
      or code:match("io%.")
    then
      return true
    end
    -- Check code length
    if #code > 150 then
      return true
    end
  end

  -- Vim command risk detection
  if type == "vim_cmd" then
    local command = action.command
    if
      command:match("^:%s*[qwabedhv]+%s*!") -- Force commands
      or command:match(":%s*g%s*/.+/d") -- Global deletion
      or command:match(":%s*[%%s]")
    then -- Full text replacement
      return true
    end
  end

  return false
end

---Outputs a message to the chat buffer that initiated the tool
---@param msg string The message to output
---@param tool CodeCompanion.Agent The tools object
---@param opts {cmd: table|string, output: table|string, message?: string}
local function to_chat(msg, tool, opts)
  local cmd
  if opts and type(opts.cmd) == "table" then
    ---@diagnostic disable-next-line: param-type-mismatch
    cmd = table.concat(opts.cmd, " ")
  else
    cmd = opts.cmd
  end
  if opts and type(opts.output) == "table" then
    opts.output = vim.iter(opts.output):flatten():join("\n")
  end

  local content
  if opts.output == "" then
    content = string.format("%s(with no output):\n%s\n\n", msg, cmd)
  else
    content = string.format(
      [[%s:
%s
Output:
```plaintext
%s
```

]],
      msg,
      cmd,
      opts.output
    )
  end

  return tool.chat:add_buf_message({
    role = config.constants.USER_ROLE,
    content = content,
  })
end

-- Execute Vim command
---@param action table Action object
---@return string Command execution result
local function execute_vim_cmd(action)
  local command = action.command
  local success, result = pcall(vim.api.nvim_exec2, command, { output = true })
  if not success then
    error(result)
  end
  return result.output
end

-- Execute Lua code
---@param action table Action object
---@return string Table containing execution results and output
local function execute_lua_code(action)
  local code = action.code

  -- Save original print output
  local old_print = print
  local output = {}

  -- Redirect print output
  ---@diagnostic disable-next-line: duplicate-set-field
  _G.print = function(...)
    local args = { ... }
    local str_args = {}
    for i, v in ipairs(args) do
      str_args[i] = tostring(v)
    end
    local str = table.concat(str_args, "\t")
    table.insert(output, str)
    old_print(...) -- Keep original output functionality
  end

  local fn, load_err = loadstring(code)
  if not fn then
    _G.print = old_print -- Restore original print
    error(load_err)
  end

  local success, result = pcall(fn)

  -- Restore original print
  _G.print = old_print
  if not success then
    error(result)
  end

  if result then
    -- if result is string
    if type(result) == "string" then
      result = "The lua code returns:\n" .. result
    else
      result = "The lua code returns:\n" .. vim.inspect(result)
    end
  end
  -- Return table containing execution results and output
  local res = table.concat(output, "\n") .. (result or "")
  return res
end

-- Operation type mapping table
local actions = {
  vim_cmd = execute_vim_cmd,
  lua_exec = execute_lua_code,
}

---@class CodeCompanion.Tool
return {
  name = "nvim_runner",
  actions = actions,
  cmds = {
    ---Execute the Neovim operations
    ---@param action table The action object
    ---@return { status: string, msg: string }
    function(_, action, _)
      local action_type = action._attr.type
      if not actions[action_type] then
        return { status = "error", msg = "Unknown action type: " .. action_type }
      end

      local ok, result = pcall(actions[action_type], action)
      if not ok then
        return { status = "error", msg = result, data = result }
      end

      return { status = "success", msg = result, data = result }
    end,
  },
  schema = {
    {
      tool = {
        _attr = { name = "nvim_runner" },
        action = {
          _attr = { type = "vim_cmd" },
          command = "<![CDATA[:echo 'Hello from Neovim!']]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "nvim_runner" },
        action = {
          _attr = { type = "lua_exec" },
          code = "<![CDATA[return 'Current buffer: ' .. vim.api.nvim_get_current_buf()]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "nvim_runner" },
        action = {
          {
            _attr = { type = "vim_cmd" },
            command = "<![CDATA[:new]]>",
          },
          {
            _attr = { type = "lua_exec" },
            code = "<![CDATA[print('New buffer created!')]]>",
          },
        },
      },
    },
  },
  system_prompt = function(schema)
    return string.format(
      [[# Neovim Runner Tool (`nvim_runner`) – Usage Guidelines
Execute Neovim commands and Lua code directly within your Neovim instance.

**Neovim Version**: %s

IMPORTANT: You should NEVER assume you're in the target buffer. If you need to fetch buffer number, NEVER use `vim.api.nvim_get_current_buf()`.

## Description
- tool name: `nvim_runner`
- sequential execution: yes
- action type: `vim_cmd`
  - element `command`
    - Vim command to execute.
    - CDATA: yes
- action type: `lua_exec`
  - element `code`
    - Lua code to execute.
    - CDATA: yes
    ]],
      vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
    )
  end,
  handlers = {},

  output = {
    ---@param agent CodeCompanion.Agent
    ---@param self CodeCompanion.Agent.Tool
    prompt = function(agent, self)
      local action_list = self.request.action
      if action_list._attr ~= nil then
        action_list = { action_list }
      end
      -- Create prompts for different operation types
      local prompts = {
        vim_cmd = function(a)
          return string.format("vim: `%s`", a.command)
        end,

        lua_exec = function(a)
          -- Truncate long code display
          local code = a.code
          if #code > 60 then
            code = code:sub(1, 57) .. "..."
          end
          return string.format("lua: `%s`", code)
        end,
      }

      local res = "Approve the following execution?:\n\n"
      for _, action in ipairs(action_list) do
        local prompt_fn = prompts[action._attr.type]
          or function(_)
            return string.format("Execute %s operation?", string.upper(action._attr.type))
          end
        local prompt = prompt_fn(action)
        -- Add warning for high-risk operations
        if is_high_risk(action) then
          prompt = "⚠️ HIGH RISK OPERATION! " .. prompt
        end
        res = res .. prompt .. "\n"
      end
      return res
    end,

    ---Rejection message back to the LLM
    ---@param agent CodeCompanion.Agent The tools object
    rejected = function(agent)
      if not vim.g.codecompanion_auto_tool_mode then
        agent.status = "rejected"
      end
      agent.chat:add_buf_message({
        content = "I reject to execute tool `nvim_runner`\n",
        role = config.constants.USER_ROLE,
      })
    end,

    ---@param agent CodeCompanion.Agent The tools object
    ---@param action table The action object
    ---@param err string Error message
    error = function(agent, action, err)
      local action_type = action._attr.type
      local display_cmd = ""
      if action_type == "lua_exec" then
        action.code = string.gsub(action.code, "^%s*(.-)%s*$", "%1")
        display_cmd =
          string.format("~~~~~lua\n%s\n~~~~~", action.code:sub(1, 120) .. (#action.code > 120 and "\n-- ..." or ""))
      elseif action_type == "vim_cmd" then
        display_cmd = string.format("```vim\n%s\n```", string.gsub(action.command, "^%s*(.-)%s*$", "%1"))
      end

      to_chat("Execution failed. Error executing", agent, {
        cmd = display_cmd,
        output = err,
      })
    end,

    ---@param agent CodeCompanion.Agent The tools object
    ---@param action table The action object
    ---@param output table The output with result
    success = function(agent, action, output)
      local action_type = action._attr.type
      local display_cmd = ""
      if action_type == "lua_exec" then
        action.code = string.gsub(action.code, "^%s*(.-)%s*$", "%1")
        display_cmd =
          string.format("~~~~~lua\n%s\n~~~~~", action.code:sub(1, 120) .. (#action.code > 120 and "\n-- ..." or ""))
      elseif action_type == "vim_cmd" then
        display_cmd = string.format("```vim\n%s\n```", string.gsub(action.command, "^%s*(.-)%s*$", "%1"))
      end

      to_chat("Execution succeeded. Result of executing", agent, {
        cmd = display_cmd,
        output = output,
      })
    end,
  },
}
