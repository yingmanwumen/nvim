--[[
*Files Tool*
This tool can be used make edits to files on disk. It can handle multiple actions
in the same XML block. All actions must be approved by you.
--]]

local Path = require("plenary.path")
local config = require("codecompanion.config")
local util = require("codecompanion.utils")
local xml2lua = require("codecompanion.utils.xml.xml2lua")

local fmt = string.format
local file = nil

---Read the contents of af ile
---@param action table The action object
---@return table<string, string>
local function read(action)
  local p = Path:new(action.path)
  p.filename = p:expand()
  file = {
    content = p:read(),
    filetype = vim.fn.fnamemodify(p.filename, ":e"),
  }
  return file
end

---Read the contents of a file between specific lines
---@param action table The action object
---@return nil
local function read_lines(action)
  local p = Path:new(action.path)
  p.filename = p:expand()

  -- Read requested lines
  local extracted = {}
  local current_line = 0

  local lines = p:iter()

  -- Parse line numbers
  local start_line = tonumber(action.start_line) or 1
  local end_line = tonumber(action.end_line) or #lines

  for line in lines do
    current_line = current_line + 1
    if current_line >= start_line and current_line <= end_line then
      table.insert(extracted, current_line .. ":  " .. line)
    end
    if current_line > end_line then
      break
    end
  end

  file = {
    content = table.concat(extracted, "\n"),
    filetype = vim.fn.fnamemodify(p.filename, ":e"),
  }
  return file
end

---Edit the contents of a file
---@param action table The action object
---@return nil
local function edit(action)
  local p = Path:new(action.path)
  p.filename = p:expand()

  local content = p:read()
  if not content then
    return util.notify(fmt("No data found in %s", action.path))
  end

  local changed, substitutions_count = content:gsub(vim.pesc(action.search), action.replace:gsub("%%", "%%%%"))
  if substitutions_count == 0 then
    return util.notify(fmt("Could not find the search string in %s", action.path))
  end

  p:write(changed, "w")
end

local actions = {
  read = read,
  read_lines = read_lines,
  edit = edit,
}

---@class CodeCompanion.Tool
return {
  name = "files",
  actions = actions,
  cmds = {
    ---Execute the file commands
    ---@param self CodeCompanion.Tools The Tools object
    ---@param action table The action object
    ---@param input any The output from the previous function call
    ---@return { status: string, msg: string }
    function(self, action, input)
      local ok, data = pcall(actions[action._attr.type], action)
      if not ok then
        return { status = "error", msg = data }
      end
      return { status = "success", msg = nil }
    end,
  },
  schema = {
    {
      tool = {
        _attr = { name = "files" },
        action = {
          _attr = { type = "read" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
        },
      },
    },
    {
      tool = {
        _attr = { name = "files" },
        action = {
          _attr = { type = "read_lines" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
          start_line = "1",
          end_line = "10",
        },
      },
    },
    {
      tool = {
        _attr = { name = "files" },
        action = {
          _attr = { type = "edit" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
          search = "<![CDATA[    print('Hello World')]]>",
          replace = "<![CDATA[    print('Hello CodeCompanion')]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = "files" },
        action = {
          {
            _attr = { type = "read" },
            path = "/Users/Oli/Code/new_app/hello_world.py",
          },
          {
            _attr = { type = "edit" },
            path = "/Users/Oli/Code/new_app/hello_world.py",
            search = "<![CDATA[    print('Hello World')]]>",
            replace = "<![CDATA[    print('Hello CodeCompanion')]]>",
          },
        },
      },
    },
  },
  system_prompt = function(schema)
    return fmt(
      [[# Files Tool (`files`)
Read/Edit files.

Usage: Return an XML markdown code block for read or edit operations.

**Key Points**:
  - Ensure XML is **valid and follows the schema**
  - **Include indentation** in the file's content
  - **Don't escape** special characters
  - **Wrap contents in a CDATA block**, the contents could contain characters reserved by XML
  - The user's current working directory in Neovim is `%s`. They may refer to this in their message to you
  - Make sure the tools xml block is **surrounded by ```xml**
  - Do not hallucinate. If you can't read a file's contents, say so

## XML Schema
a) Read:

```xml
%s
```
- This will output the contents of a file at the specified path.

b) Read Lines (inclusively):

```xml
%s
```
- This will read specific line numbers (between the start and end lines, inclusively) in the file at the specified path
- This can be useful if you have been given the symbolic outline of a file and need to see more of the file's content

c) Edit:

```xml
%s
```

- This will ensure a file is edited at the specified path
- Ensure that you are terse with which text to search for and replace
- Be precise about what text to search for and what to replace it with since you may wrongly edit other parts of the file
- If the text is not found, the file will not be edited

d) **Multiple Actions**: Combine actions in one response if needed:

```xml
%s
```

## Remember
- If the user types `~` in their response, do not replace or expand it.
- Wait for the user to share the outputs with you before responding.]],
      vim.fn.getcwd(),
      xml2lua.toXml({ tools = { schema[1] } }), -- Create
      xml2lua.toXml({ tools = { schema[2] } }), -- Read
      xml2lua.toXml({ tools = { schema[3] } }), -- Extract
      xml2lua.toXml({ tools = { schema[4] } })
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

      local prompts = {
        base = function(a)
          return fmt("%s the file at `%s`?", string.upper(a._attr.type), vim.fn.fnamemodify(a.path, ":."))
        end,
        move = function(a)
          return fmt(
            "%s file from `%s` to `%s`?",
            string.upper(a._attr.type),
            vim.fn.fnamemodify(a.path, ":."),
            vim.fn.fnamemodify(a.new_path, ":.")
          )
        end,
      }

      local prompt = prompts.base(action)
      if action.new_path then
        prompt = prompts.move(action)
      end

      local ok, choice = pcall(vim.fn.confirm, prompt, "No\nYes")
      if not ok or choice ~= 2 then
        return false
      end

      return true
    end,
    on_exit = function(self)
      file = nil
    end,
  },
  output = {
    success = function(self, action, output)
      local type = action._attr.type
      local path = action.path
      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = fmt("I've shared the output from the %s action for file `%s` with you.\n", string.upper(type), path),
      })

      if file then
        self.chat:add_message({
          role = config.constants.USER_ROLE,
          content = fmt(
            [[The output from the %s action for file `%s` is:

```%s
%s
```]],
            string.upper(type),
            path,
            file.filetype,
            file.content
          ),
        }, { visible = false })
      end
    end,

    error = function(self, action, err)
      return self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = fmt(
          [[There was an error running the %s action:

```txt
%s
```]],
          string.upper(action._attr.type),
          err
        ),
      })
    end,

    rejected = function(self, action)
      return self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = fmt("I rejected the %s action.\n\n", string.upper(action._attr.type)),
      })
    end,
  },
}
