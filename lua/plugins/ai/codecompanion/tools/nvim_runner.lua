--[[
*Neovim Runner Tool*
This tool is used to run Neovim commands and execute Lua code in your Neovim instance.
All operations must be approved by you before execution.
--]]

local config = require("codecompanion.config")

local log = require("codecompanion.utils.log")
local xml2lua = require("codecompanion.utils.xml.xml2lua")

-- 判断高风险操作的辅助函数
---@param action table
---@return boolean
local function is_high_risk(action)
  local type = action._attr.type

  -- Lua执行风险检测
  if type == "lua_exec" then
    local code = action.code
    -- 检查是否包含高风险API调用
    if
      code:match("nvim_buf_delete")
      or code:match("nvim_command")
      or code:match("vim%.fn%.delete")
      or code:match("os%.execute")
      or code:match("io%.")
    then
      return true
    end
    -- 检查代码长度
    if #code > 150 then
      return true
    end
  end

  -- Vim命令风险检测
  if type == "vim_cmd" then
    local command = action.command
    if
      command:match("^:%s*[qwabedhv]+%s*!") -- 强制命令
      or command:match(":%s*g%s*/.+/d") -- 全局删除
      or command:match(":%s*[%%s]")
    then -- 全文替换
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

-- 执行Vim命令
---@param action table 动作对象
---@return string 命令执行结果
local function execute_vim_cmd(action)
  local command = action.command
  local success, result = pcall(vim.api.nvim_exec2, command, { output = true })
  if not success then
    error(result)
  end
  return result.output
end

-- 执行Lua代码
---@param action table 动作对象
---@return string 包含执行结果和输出的表
local function execute_lua_code(action)
  local code = action.code

  -- 保存原始的 print 输出
  local old_print = print
  local output = {}

  -- 重定向 print 输出
  _G.print = function(...)
    local args = { ... }
    local str = table.concat(args, "\t")
    table.insert(output, str)
    old_print(...) -- 保持原始输出功能
  end

  local fn, load_err = loadstring(code)
  if not fn then
    _G.print = old_print -- 恢复原始 print
    error(load_err)
  end

  local success, result = pcall(fn)

  -- 恢复原始 print
  _G.print = old_print
  if not success then
    error(result)
  end

  -- 返回包含执行结果和输出的表
  local res = table.concat(output, "\n")
  print(res)
  return res
end

-- 操作类型映射表
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

      -- 创建不同类型操作的提示
      local prompts = {
        vim_cmd = function(a)
          return string.format("Execute Vim command: `%s`?", a.command)
        end,

        lua_exec = function(a)
          -- 对长代码截断显示
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

      -- 对高风险操作添加警告
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
