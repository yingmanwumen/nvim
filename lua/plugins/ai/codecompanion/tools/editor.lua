--[[
*Editor Tool*
This tool is used to directly modify the contents of a buffer. It can handle
multiple edits in the same XML block.
--]]

local add_reference = require("plugins.ai.codecompanion.utils.add_reference")
local config = require("codecompanion.config")

local keymaps = require("codecompanion.utils.keymaps")
local ui = require("codecompanion.utils.ui")

local api = vim.api

local diff_started = false

-- To keep track of the changes made to the buffer, we store them in this table
local deltas = {}
local function add_delta(bufnr, line, delta)
  table.insert(deltas, { bufnr = bufnr, line = line, delta = delta })
end

---Scroll the window to center the specified line
---@param bufnr number The buffer number
---@param line? number The line to scroll to (default: 1)
local function scroll_to_line(bufnr, line)
  line = line or 1
  local winnr = ui.buf_get_win(bufnr)
  if winnr then
    api.nvim_win_set_cursor(winnr, { line, 0 })
    vim.api.nvim_set_current_win(winnr)
  end
end

---Calculate if there is any intersection between the lines
---@param bufnr number
---@param line number
local function intersect(bufnr, line)
  local delta = 0
  for _, v in ipairs(deltas) do
    if bufnr == v.bufnr and line > v.line then
      delta = delta + v.delta
    end
  end
  return delta
end

---Delete lines from the buffer
---@param bufnr number
---@param action table
local function delete(bufnr, action)
  local start_line
  local end_line
  if action.all then
    start_line = 1
    end_line = api.nvim_buf_line_count(bufnr)
  else
    start_line = tonumber(action.start_line)
    assert(start_line, "No start line number provided by the LLM")
    if start_line == 0 then
      start_line = 1
    end

    end_line = tonumber(action.end_line)
    assert(end_line, "No end line number provided by the LLM")
    if end_line == 0 then
      end_line = 1
    end
  end

  local delta = intersect(bufnr, start_line)

  api.nvim_buf_set_lines(bufnr, start_line + delta - 1, end_line + delta, false, {})
  add_delta(bufnr, start_line, (start_line - end_line - 1))
end

---Add lines to the buffer
---@param bufnr number
---@param action table
local function add(bufnr, action)
  if not action.line and not action.replace then
    assert(false, "No line number or replace request provided by the LLM")
  end

  local start_line
  if action.replace then
    -- Clear the entire buffer
    delete(bufnr, { start_line = 1, end_line = api.nvim_buf_line_count(bufnr) })
    start_line = 1
  else
    start_line = tonumber(action.line)
    assert(start_line, "No line number provided by the LLM")
    if start_line == 0 then
      start_line = 1
    end
  end

  local delta = intersect(bufnr, start_line)

  local lines = vim.split(action.code, "\n", { plain = true, trimempty = false })
  api.nvim_buf_set_lines(bufnr, start_line + delta - 1, start_line + delta - 1, false, lines)

  add_delta(bufnr, start_line, tonumber(#lines))
end

---@class CodeCompanion.Agent.Tool
return {
  name = "editor",
  cmds = {
    ---Ensure the final function returns the status and the output
    ---@param self CodeCompanion.Agent.Tool The Tools object
    ---@param actions table The action object
    ---@param input? any The output from the previous function call
    ---@return { status: string, msg: string }
    function(self, actions, input)
      ---Run the action
      ---@param action table
      local function run(action)
        local type = action._attr.type

        if not action.buffer then
          return { status = "error", msg = "No buffer number provided by the LLM" }
        end
        local bufnr = tonumber(action.buffer)
        assert(bufnr, "Buffer number conversion failed")
        local is_valid, _ = pcall(api.nvim_buf_is_valid, bufnr)
        assert(is_valid, "Invalid buffer number")

        local winnr = ui.buf_get_win(bufnr)

        -- Diff the buffer
        if
          not vim.g.codecompanion_auto_tool_mode
          and (not diff_started and config.display.diff.enabled and bufnr and vim.bo[bufnr].buftype ~= "terminal")
        then
          local provider = config.display.diff.provider
          local ok, diff = pcall(require, "codecompanion.providers.diff." .. provider)

          if ok and winnr then
            ---@type CodeCompanion.DiffArgs
            local diff_args = {
              bufnr = bufnr,
              contents = api.nvim_buf_get_lines(bufnr, 0, -1, true),
              filetype = api.nvim_get_option_value("filetype", { buf = bufnr }),
              winnr = winnr,
            }
            ---@type CodeCompanion.Diff
            diff = diff.new(diff_args)
            keymaps
              .new({
                bufnr = bufnr,
                callbacks = require("codecompanion.strategies.inline.keymaps"),
                data = { diff = diff },
                keymaps = config.strategies.inline.keymaps,
              })
              :set()

            diff_started = true
          end
        end

        if type == "add" then
          add(bufnr, action)
        elseif type == "delete" then
          delete(bufnr, action)
        elseif type == "update" then
          delete(bufnr, action)

          action.line = action.start_line
          add(bufnr, action)
        end

        if action.line then
          scroll_to_line(bufnr, tonumber(action.line))
        elseif action.start_line then
          scroll_to_line(bufnr, tonumber(action.start_line))
        end

        return { status = "success", msg = nil }
      end

      local output = {}
      if vim.isarray(actions) then
        for _, v in ipairs(actions) do
          output = run(v)
          if output.status == "error" then
            break
          end
        end
      else
        output = run(actions)
      end

      return output
    end,
  },
  schema = {
    {
      tool = {
        _attr = { name = "editor" },
        action = {
          _attr = { type = "add" },
          buffer = 1,
          line = 203,
          code = "<![CDATA[    print('Hello World')]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "editor" },
        action = {
          _attr = { type = "add" },
          buffer = 1,
          replace = true,
          code = "<![CDATA[    print('Hello World')]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "editor" },
        action = {
          _attr = { type = "update" },
          buffer = 10,
          start_line = 50,
          end_line = 99,
          code = "<![CDATA[   function M.capitalize()]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "editor" },
        action = {
          _attr = { type = "delete" },
          buffer = 14,
          start_line = 10,
          end_line = 15,
        },
      },
    },
    {
      tool = {
        _attr = { name = "editor" },
        action = {
          _attr = { type = "delete" },
          buffer = 14,
          all = true,
        },
      },
    },
    {
      tool = {
        _attr = { name = "editor" },
        action = {
          {
            _attr = { type = "delete" },
            buffer = 5,
            start_line = 13,
            end_line = 13,
          },
          {
            _attr = { type = "add" },
            buffer = 5,
            line = 20,
            code = "<![CDATA[function M.hello_world()]]>",
          },
        },
      },
    },
  },
  system_prompt = function(schema)
    return string.format([[# Editor Tool (`editor`) - Usage Guidelines
Purpose: Modify the content of a Neovim buffer by adding, updating, or deleting code when explicitly requested.

When to Use: Use this tool solely for buffer edit operations. Other file tasks should be handled by the designated tools.

## Description
- tool name: `editor`
- sequential execution: yes
- action type: `add`
  - element `buffer`
    - the buffer number that the user has shared with you. If this is not given, try to fetch it by yourself first. If failed, ask for it.
  - element `line`
    - the line number where the code should be added. All line number is 1-indexed.
  - element `code`
    - the code to be added.
    - CDATA: yes
- action type: `update`
  - description: The update action first deletes the range defined in <start_line> to <end_line> (inclusive) and then adds the new code starting from <start_line>
  - element `buffer`
  - element `start_line`
  - element `end_line`
  - element `code`
      - CDATA: yes
- action type: `delete`
  - when deleting a range
    - element `buffer`
    - element `start_line`
    - element `end_line`
  - when deleting the entire buffer
    - element `buffer`
    - element `all`: always be true



IMPORTANT: Buffer number must be valid. You should either fetch it from user or via other tools.
]])
  end,
  handlers = {
    on_exit = function(agent)
      deltas = {}
      diff_started = false
    end,
  },
  output = {
    ---@param agent CodeCompanion.Agent
    ---@param cmd table
    rejected = function(agent, cmd)
      if not vim.g.codecompanion_auto_tool_mode then
        agent.status = "rejected"
      end
      return agent.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = string.format("I rejected the action in `editor`.\n"),
      })
    end,

    ---@param agent CodeCompanion.Agent
    ---@param cmd table The command that was executed
    ---@param stdout table
    success = function(agent, cmd, stdout)
      vim.notify("The editor tool executed successfully")
      agent.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = string.format("`editor` tool executed successfully\n"),
      })
      local bufname = vim.api.nvim_buf_get_name(tonumber(cmd.buffer, 10))
      add_reference(agent.chat, {
        role = config.constants.USER_ROLE,
        content = string.format(
          "The latest content of buffer %s(%s) is inside `<buffer_content>` block:\n<buffer_content>\n%s\n</buffer_content>",
          cmd.buffer,
          bufname,
          -- get the content of the buffer
          table.concat(vim.api.nvim_buf_get_lines(tonumber(cmd.buffer, 10), 0, -1, false), "\n")
        ),
      }, "tool", "<editor>" .. bufname .. "</editor>")
      return agent
    end,

    ---@param agent CodeCompanion.Agent
    ---@param cmd table
    ---@param stderr table
    ---@param stdout? table
    error = function(agent, cmd, stderr, stdout)
      if type(stderr) == "table" then
        stderr = vim
          .iter(stderr)
          :map(function(v)
            return v
          end)
          :join("\n")
      end
      return agent.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = string.format(
          [[There was an error running `editor`:
```txt
%s
```
]],
          stderr
        ),
      })
    end,
  },
}
