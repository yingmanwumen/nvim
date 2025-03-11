--[[
*Files Tool*
This tool can be used make edits to files on disk. It can handle multiple actions
in the same XML block. All actions must be approved by you.
--]]

local Path = require("plenary.path")
local add_reference = require("plugins.ai.codecompanion.utils.add_reference")
local config = require("codecompanion.config")

local util = require("codecompanion.utils")

local fmt = string.format
local file = nil

---Create a file and it's surrounding folders
---@param action table The action object
---@return nil
local function create(action)
  local p = Path:new(action.path)
  p.filename = p:expand()
  p:touch({ parents = true })
  p:write(action.contents or "", "w")
end

---Read the contents of af ile
---@param action table The action object
---@return table<string, string>
local function read(action)
  local p = Path:new(action.path)
  p.filename = p:expand()
  file = {
    path = p.filename,
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
    path = p.filename,
    content = table.concat(extracted, "\n"),
    filetype = vim.fn.fnamemodify(p.filename, ":e"),
    range = start_line .. "-" .. end_line,
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
    error("No data found in " .. action.path)
  end

  local changed, substitutions_count = content:gsub(vim.pesc(action.search), vim.pesc(action.replace))
  if substitutions_count == 0 then
    error("Could not find the search string in " .. action.path)
  end

  p:write(changed, "w")
end

---Delete a file
---@param action table The action object
---@return nil
local function delete(action)
  local p = Path:new(action.path)
  p.filename = p:expand()
  p:rm()
end

---Rename a file
---@param action table The action object
---@return nil
local function rename(action)
  local p = Path:new(action.path)
  p.filename = p:expand()

  local new_p = Path:new(action.new_path)
  new_p.filename = new_p:expand()

  p:rename({ new_name = new_p.filename })
end

---Copy a file
---@param action table The action object
---@return nil
local function copy(action)
  local p = Path:new(action.path)
  p.filename = p:expand()

  local new_p = Path:new(action.new_path)
  new_p.filename = new_p:expand()

  p:copy({ destination = new_p.filename, parents = true })
end

---Move a file
---@param action table The action object
---@return nil
local function move(action)
  local p = Path:new(action.path)
  p.filename = p:expand()

  local new_p = Path:new(action.new_path)
  new_p.filename = new_p:expand()

  p:copy({ destination = new_p.filename, parents = true })
  p:rm()
end

local actions = {
  create = create,
  read = read,
  read_lines = read_lines,
  edit = edit,
  delete = delete,
  rename = rename,
  copy = copy,
  move = move,
}

---@class CodeCompanion.Tool
return {
  name = "files",
  actions = actions,
  cmds = {
    ---Execute the file commands
    ---@param self CodeCompanion.Agent.Tool The Tools object
    ---@param action table The action object
    ---@param input any The output from the previous function call
    ---@return { status: string, msg: string }
    function(self, action, input)
      local ok, data = pcall(actions[action._attr.type], action)
      if not ok then
        return { status = "error", msg = data, data = data }
      end
      return { status = "success", msg = nil }
    end,
  },
  schema = {
    {
      tool = {
        _attr = { name = "files" },
        action = {
          _attr = { type = "create" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
          contents = "<![CDATA[    print('Hello World')]]>",
        },
      },
    },
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
          _attr = { type = "delete" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
        },
      },
    },
    {
      tool = {
        _attr = { name = "files" },
        action = {
          _attr = { type = "rename" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
          new_path = "/Users/Oli/Code/new_app/new_hello_world.py",
        },
      },
    },
    {
      tool = {
        _attr = { name = "files" },
        action = {
          _attr = { type = "copy" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
          new_path = "/Users/Oli/Code/old_app/hello_world.py",
        },
      },
    },
    {
      tool = {
        _attr = { name = "files" },
        action = {
          _attr = { type = "move" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
          new_path = "/Users/Oli/Code/new_app/new_folder/hello_world.py",
        },
      },
    },
    {
      tool = { name = "files" },
      action = {
        {
          _attr = { type = "create" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
          contents = "<![CDATA[    print('Hello World')]]>",
        },
        {
          _attr = { type = "edit" },
          path = "/Users/Oli/Code/new_app/hello_world.py",
          contents = "<![CDATA[    print('Hello CodeCompanion')]]>",
        },
      },
    },
  },
  system_prompt = function(schema)
    return string.format([[# Files Tool (`files`)
Read/Edit files.

**Key Points**:
- **Include indentation** in the file's content
- **Don't escape** special characters
- Do not hallucinate. If you can't read a file's contents, say so
- If the user types `~` in their response, do not replace or expand it.

IMPORTANT: If no context is provided, you should always fetch the latest buffer content before making any changes. This is important especially when doing search/replace operations, for the content might be changed/formatted. Operations like running `cargo fmt` or something else might also change the content of the file.

## Description
- tool name: `files`
- sequential execution: yes
- action type `read`: Read the contents of a file
  - element `path`
    - CDATA: no
- action type `read_lines`: Read a range of lines from a file
  - element `path`
  - element `start_line`
    - CDATA: no
  - element `end_line`
    - CDATA: no
- action type `edit`: Edit the contents of a file
  - element `path`
  - element `search`: pattern to search for. Attention: be careful with white characters. This is not a regex search.
    - CDATA: yes
  - element `replace`: pattern to replace
    - CDATA: yes
- action type `create`: Create a file
  - element `path`
  - element `contents`: contents of the file
    - CDATA: yes
- action type `delete`: Delete a file
  - element `path`
- action type `rename`: Rename a file
  - element `path`
  - element `new_path`
- action type `copy`: Copy a file
  - element `path`
  - element `new_path`
- action type `move`: Move a file
  - element `path`
  - element `new_path`

HINT: Sometimes you don't have to read the full contents of a file. Instead, specific lines of a file might be enough.
HINT: If search/replace doesn't work, you can also try to delete lines and add new ones.
    ]])
  end,
  handlers = {
    ---@param agent CodeCompanion.Agent The agent object
    ---@return nil
    on_exit = function(agent)
      file = nil
    end,
  },
  output = {
    ---The message which is shared with the user when asking for their approval
    ---@param agent CodeCompanion.Agent
    ---@param self CodeCompanion.Agent.Tool
    ---@return string
    prompt = function(agent, self)
      local prompts = {}

      local responses = {
        create = "Create a file at %s?",
        read = "Read %s?",
        read_lines = "Read specific lines in %s?",
        edit = "Edit %s?",
        delete = "Delete %s?",
        copy = "Copy %s?",
        rename = "Rename %s to %s?",
        move = "Move %s to %s?",
      }

      for _, action in ipairs(self.request.action) do
        local path = vim.fn.fnamemodify(action.path, ":.")
        local new_path = vim.fn.fnamemodify(action.new_path, ":.")
        local type = string.lower(action._attr.type)

        if type == "rename" or type == "move" then
          table.insert(prompts, fmt(responses[type], path, new_path))
        else
          table.insert(prompts, fmt(responses[type], path))
        end
      end

      return table.concat(prompts, "\n")
    end,

    ---@param agent CodeCompanion.Agent The agent object
    ---@param action table
    ---@param output table
    ---@return nil
    success = function(agent, action, output)
      local type = action._attr.type
      local path = action.path
      -- util.notify(fmt("The files tool executed successfully for the `%s` file", vim.fn.fnamemodify(path, ":t")))
      local p = Path:new(path)
      p.filename = p:expand()

      if file then
        local content = fmt(
          [[The output from the %s action for file `%s` is:
```%s
%s
```]],
          string.upper(type),
          p.filename,
          file.filetype,
          file.content
        )
        if file.range then
          content = fmt(
            [[The output from the %s action for file `%s`(line range: %s) is:
```%s
%s
```]],
            string.upper(type),
            p.filename,
            file.range,
            file.filetype,
            file.content
          )
        end
        add_reference(agent.chat, {
          role = config.constants.USER_ROLE,
          content = content,
        }, "tool", "<file>" .. file.path .. "</file>")
      else
        local content = fmt(
          [[The latest content of the file `%s` is:
%s]],
          p.filename,
          -- get the content of the file
          p:read()
        )
        add_reference(agent.chat, {
          role = config.constants.USER_ROLE,
          content = content,
        }, "tool", "<file>" .. p.filename .. "</file>")
      end
      agent.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = fmt("The files tool executed successfully for the file `%s`", p.filename),
      })
    end,

    ---@param agent CodeCompanion.Agent The agent object
    ---@param action table
    ---@param err string
    ---@return nil
    error = function(agent, action, err)
      return agent.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = fmt(
          [[There was an error running the %s action:

```txt
%s
```]],
          string.upper(action._attr.type),
          type(err) == "string" and err or vim.inspect(err)
        ),
      })
    end,

    ---The action to take if the user rejects the command
    ---@param agent CodeCompanion.Agent The agent object
    ---@return nil
    rejected = function(agent)
      if not vim.g.codecompanion_auto_tool_mode then
        agent.status = "rejected"
      end
      return agent.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = fmt("I rejected to run tool `files`.\n"),
      })
    end,
  },
}
