--[[
* Memory Tool*
This tool can be used to store and retrieve information from a persistent memory file.
--]]

local config = require("codecompanion.config")
local xml2lua = require("codecompanion.utils.xml.xml2lua")
local tool_name = "memory"
local ACTION_UPDATE = "update"
local ACTION_QUERY = "query"
local ACTION_SAVE_BUFFER = "save_buffer"
local MEMORY_FILE = os.getenv("HOME") .. "/.config/codecompanion/memory.md"
local MEMORY_DIR = os.getenv("HOME") .. "/.config/codecompanion/memory"

local function extract_action(action)
  local type = action._attr.type

  if type == ACTION_UPDATE then
    local content = action.content
    local title = action.title or "Untitled"
    local tags = action.tags or ""

    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local entry = string.format("\n## [%s] %s\nTags: %s\n\n%s\n\n---\n", timestamp, title, tags, content)

    return {
      action = "update",
      entry = entry,
      memory_file = MEMORY_FILE,
    }
  elseif type == ACTION_QUERY then
    local search_term = action.query or ""

    return {
      action = "query",
      search_term = search_term,
      memory_file = MEMORY_FILE,
    }
  elseif type == ACTION_SAVE_BUFFER then
    local summary = action.summary or "Chat Record"

    return {
      action = "save_buffer",
      summary = summary,
    }
  end
end

---@class CodeCompanion.Tool
return {
  name = tool_name,
  cmds = {
    function(self, raw_action)
      local action = extract_action(raw_action)

      -- Create directory if it doesn't exist
      local dir = vim.fn.fnamemodify(MEMORY_FILE, ":h")
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
      end

      -- Create file if it doesn't exist
      if vim.fn.filereadable(MEMORY_FILE) == 0 then
        local file = io.open(MEMORY_FILE, "w")
        if file then
          file:write("# CodeCompanion Memory\n\n")
          file:close()
        end
      end

      if action.action == "update" then
        -- Append to the memory file
        local file = io.open(MEMORY_FILE, "a")
        if file then
          file:write(action.entry)
          file:close()
          return { status = "success", msg = "Memory updated successfully" }
        else
          return { status = "error", msg = "Failed to open memory file for writing" }
        end
      elseif action.action == "query" then
        -- Read and search the memory file
        local file = io.open(MEMORY_FILE, "r")
        if not file then
          return { status = "error", msg = "Memory file not found" }
        end

        local content = file:read("*all")
        file:close()

        if action.search_term == "" then
          return { status = "success", msg = content }
        else
          -- Simple search implementation - could be enhanced with pattern matching
          local results = {}
          local current_section = ""
          local in_matching_section = false

          for line in content:gmatch("[^\r\n]+") do
            if line:match("^## %[") then
              current_section = line
              in_matching_section = line:lower():find(action.search_term:lower(), 1, true) ~= nil

              if in_matching_section then
                table.insert(results, "\n" .. line)
              end
            elseif in_matching_section then
              table.insert(results, line)
            elseif line:lower():find(action.search_term:lower(), 1, true) then
              if not in_matching_section then
                table.insert(results, "\n" .. current_section)
                in_matching_section = true
              end
              table.insert(results, line)
            end
          end

          if #results > 0 then
            return { status = "success", msg = table.concat(results, "\n") }
          else
            return { status = "success", msg = "No results found for: " .. action.search_term }
          end
        end
      elseif action.action == "save_buffer" then
        -- Create date-based directory structure
        local date_dir = MEMORY_DIR .. "/" .. os.date("%Y-%m-%d")
        if vim.fn.isdirectory(date_dir) == 0 then
          vim.fn.mkdir(date_dir, "p")
        end

        -- Get current buffer content
        local buffer_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        -- Create filename from summary
        local sanitized_summary = action.summary:gsub("[^%w%s-]", ""):gsub("%s+", "-")
        local timestamp = os.date("%H%M%S")
        local filename = date_dir .. "/" .. sanitized_summary .. "-" .. timestamp .. ".md"

        -- Save content to file
        local file = io.open(filename, "w")
        if file then
          file:write("# " .. action.summary .. "\n\n")
          file:write(table.concat(buffer_content, "\n"))
          file:close()
          return { status = "success", msg = "Buffer saved to " .. filename }
        else
          return { status = "error", msg = "Failed to save buffer to file" }
        end
      end

      return { status = "error", msg = "Unknown action" }
    end,
  },
  schema = {
    {
      tool = {
        _attr = { name = tool_name },
        action = {
          _attr = { type = ACTION_UPDATE },
          title = "<![CDATA[Important Information]]>",
          tags = "<![CDATA[#important #reference]]>",
          content = "<![CDATA[This is important information that should be remembered for future reference.]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = tool_name },
        action = {
          _attr = { type = ACTION_QUERY },
          query = "<![CDATA[important]]>",
        },
      },
    },
    {
      tool = {
        _attr = { name = tool_name },
        action = {
          _attr = { type = ACTION_SAVE_BUFFER },
          summary = "<![CDATA[memory_tool_features]]>",
        },
      },
    },
  },
  system_prompt = function(schema)
    -- Load current memory content for context
    local memory_content = ""
    local file = io.open(MEMORY_FILE, "r")
    if file then
      memory_content = file:read("*all")
      file:close()
    end
    return string.format(
      [[# Memory Tool(`memory`) -- Usage Guidelines
This tool allows you to store and retrieve information for future reference.

**How it works**: You ask user to execute this tool via xml, so you have to wait for the result from user's feedback.

Usage: Return an XML markdown code block to update or query the memory.

## Key Points
- Use it to store important information that may be useful in future conversations
- Use it to retrieve previously stored information
- Use it to save the current buffer to a dated file

Note: It is on you to decide when to store and retrieve information. You should prefer to use this tool when it comes with information related to the user to improve his experience. Sensitive information such as password must not be stored in the memory.

## Description
- tool name: `memory`
- sequential execution: no
- action type: `update`
  - element `title`
    - title of the entry.
    - CDATA: yes
  - element `tags`
    - tags for better organization.
    - CDATA: yes
  - element `content`
    - the content to save.
    - CDATA: yes
- action type: `query`
  - element `query`
    - search term. If empty, returns all content.
    - CDATA: yes
- action type `save_buffer`: to save the current buffer
  - element `summary`
    - summary of the buffer content.
    - CDATA: yes

# History Context
%s
    ]],
      memory_content
    )

    --     return string.format(
    --       [[# Memory Tool(`memory`) -- Usage Guidelines
    -- This tool allows you to store and retrieve information for future reference.
    --
    -- **How it works**: You ask user to execute this tool via xml, so you have to wait for the result from user's feedback.
    --
    -- Usage: Return an XML markdown code block to update or query the memory.
    --
    -- ## Key Points
    -- - Use it to store important information that may be useful in future conversations
    -- - Use it to retrieve previously stored information
    -- - Use it to save the current buffer to a dated file
    -- - Ensure XML is **valid and follows the schema**
    -- - **Wrap content in a CDATA block**
    -- - Make sure the tools xml block is **surrounded by ```xml**
    --
    -- Note: It is on you to decide when to store and retrieve information. You should prefer to use this tool when it comes with information related to the user to improve his experience. Sensitive information such as password must not be stored in the memory.
    --
    -- ## XML Format
    --
    -- a) **Update memory**:
    --
    -- ```xml
    -- %s
    -- ```
    --
    -- b) **Query memory**:
    --
    -- ```xml
    -- %s
    -- ```
    --
    -- c) **Save buffer**:
    --
    -- ```xml
    -- %s
    -- ```
    -- # History Context
    -- %s
    --       ]],
    --       xml2lua.toXml({ tools = { schema[1] } }),
    --       xml2lua.toXml({ tools = { schema[2] } }),
    --       xml2lua.toXml({ tools = { schema[3] } }),
    --       memory_content
    --     )
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

      local action_type = action._attr.type

      local prompt = action_type == ACTION_UPDATE and "Allow updating memory with new information?"
        or (action_type == ACTION_QUERY and "Allow querying memory?" or "Allow saving current buffer to memory file?")

      local ok, choice = pcall(vim.fn.confirm, prompt, "No\nYes")
      if not ok or choice ~= 2 then
        return false
      end
      return true
    end,
  },
  output = {
    error = function(self, _, error_msg)
      if type(error_msg) == "table" then
        error_msg = table.concat(error_msg, "\n")
      end

      self.chat:add_message({
        role = config.constants.USER_ROLE,
        content = string.format(
          [[There was an error with the memory tool:

<error>
%s
</error>
]],
          error_msg
        ),
      }, { visible = false })

      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "I've shared the error from the memory tool with you.\n",
      })
    end,

    success = function(self, cmd, result)
      if type(result) == "table" then
        result = table.concat(result, "\n")
      end

      self.chat:add_message({
        role = config.constants.USER_ROLE,
        content = string.format(
          [[Here is the result from the memory tool:

<content>
%s
</content>
]],
          result
        ),
      }, { visible = false })

      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "I've shared the result from the memory tool with you.\n",
      })
    end,

    rejected = function(self, _)
      self.chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "I rejected the memory tool operation.\n",
      })
    end,
  },
}
