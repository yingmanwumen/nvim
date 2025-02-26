--[[
*Neovim Runner Tool*
This tool is used to run Neovim commands and execute Lua code in your Neovim instance.
All operations must be approved by you before execution.
--]]

local config = require("codecompanion.config")

local log = require("codecompanion.utils.log")
local xml2lua = require("codecompanion.utils.xml.xml2lua")

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

---@class NvimRunner.ChatOpts
---@field cmd table|string The command that was executed
---@field output table|string The output of the command

---Outputs a message to the chat buffer that initiated the tool
---@param msg string The message to output
---@param tool CodeCompanion.Tools The tools object
---@param opts NvimRunner.ChatOpts
local function to_chat(msg, tool, opts)
  if type(opts.output) == "table" then
    ---@diagnostic disable-next-line: param-type-mismatch
    opts.output = table.concat(opts.output, "\n")
  end

  local content
  if opts.output == "" then
    content = string.format(
      [[%s: `%s`.

]],
      msg,
      opts.cmd
    )
  else
    content = string.format(
      [[%s: `%s`:

```txt
%s
```

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
  _G.print = function(...)
    local args = { ... }
    local str = table.concat(args, "\t")
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
    result = "The lua code returns:\n" .. vim.inspect(result)("\n\n")
  end
  -- Return table containing execution results and output
  local res = table.concat(output, "\n") .. (result or "")
  print(res)
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
        return { status = "error", msg = result }
      end

      return { status = "success", msg = result }
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
      [[### Neovim Runner Tool (`nvim_runner`) – Usage Guidelines

1. **Purpose**:
  - Execute Neovim commands and Lua code directly within your Neovim instance.

2. **When to Use**:
  - Any time when you need to execute a lua script or a Vim command.
  - Perfect for automating editor operations, retrieving editor state, or executing complex editing sequences.

3. **How it is works**: You ask user to execute this tool via xml, so you have to wait for the result from user's feedback.

4. **Execution Format**:
  - Always return an XML markdown code block.
  - Each operation should follow the XML schema exactly.
  - If several operations need to run sequentially, combine them in one XML block.

5. **XML Schema**: The XML must be valid. Each operation follows one of these structures:

  a) Execute Vim command:

  ```xml
  %s
  ```

  b) Execute Lua code:

  ```xml
  %s
  ```

  c) Execute multiple operations sequentially:

  ```xml
  %s
  ```

#### Key Considerations
- **Safety First:** All operations will require user approval before execution.
- **Neovim Version**: %s
- **Limitations:**
  - Access to potentially destructive API functions is restricted
  - System-level operations are not permitted through this tool

#### Reminder
- Every operation requires user approval
- Be precise in your commands
- Chain multiple operations together
- Avoid unnecessarily complex operations]],
      xml2lua.toXml({ tools = { schema[1] } }), -- Vim命令
      xml2lua.toXml({ tools = { schema[2] } }), -- Lua执行
      xml2lua.toXml({ -- 多命令
        tools = {
          tool = {
            _attr = { name = "nvim_runner" },
            action = {
              schema[3].tool.action[1],
              schema[3].tool.action[2],
            },
          },
        },
      }),
      vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
    )
  end,
  handlers = {
    ---@param action table
    ---@return boolean
    approved = function(_, action)
      if vim.g.codecompanion_auto_tool_mode then
        log:info("[Nvim Runner Tool] Auto-approved operation")
        return true
      end

      local action_type = action._attr.type

      -- Create prompts for different operation types
      local prompts = {
        vim_cmd = function(a)
          return string.format("Execute Vim command: `%s`?", a.command)
        end,

        lua_exec = function(a)
          -- Truncate long code display
          local code = a.code
          if #code > 60 then
            code = code:sub(1, 57) .. "..."
          end
          return string.format("Execute Lua code: `%s`?", code)
        end,
      }

      local prompt_fn = prompts[action_type]
        or function(_)
          return string.format("Execute %s operation?", string.upper(action_type))
        end

      local prompt = prompt_fn(action)

      -- Add warning for high-risk operations
      if is_high_risk(action) then
        prompt = "⚠️ HIGH RISK OPERATION! " .. prompt
      end

      local ok, choice = pcall(vim.fn.confirm, prompt, "No\nYes")
      if not ok or choice ~= 2 then
        log:info("[Nvim Runner Tool] Rejected %s operation", string.upper(action_type))
        return false
      end

      log:info("[Nvim Runner Tool] Approved %s operation", string.upper(action_type))
      return true
    end,
  },

  output = {
    ---Rejection message back to the LLM
    rejected = function(self, action)
      local action_type = action._attr.type
      local display_cmd = action.command
      if action_type == "lua_exec" then
        display_cmd = "Lua: " .. action.code:sub(1, 40) .. (#action.code > 40 and "..." or "")
      end

      to_chat("I chose not to execute", self, {
        cmd = display_cmd,
        output = "",
      })
    end,

    ---@param self CodeCompanion.Tools The tools object
    ---@param action table The action object
    ---@param err string Error message
    error = function(self, action, err)
      local action_type = action._attr.type
      local display_cmd = action.command
      if action_type == "lua_exec" then
        display_cmd = "Lua: " .. action.code:sub(1, 40) .. (#action.code > 40 and "..." or "")
      end

      to_chat("Error executing", self, {
        cmd = display_cmd,
        output = err,
      })
    end,

    ---@param self CodeCompanion.Tools The tools object
    ---@param action table The action object
    ---@param output table The output with result
    success = function(self, action, output)
      local action_type = action._attr.type
      local display_cmd = action.command
      if action_type == "lua_exec" then
        display_cmd = "Lua: " .. action.code:sub(1, 40) .. (#action.code > 40 and "..." or "")
      end

      to_chat("Result of executing", self, {
        cmd = display_cmd,
        output = output,
      })
    end,
  },
}
