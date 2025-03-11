local config = require("codecompanion.config")

local has_been_reasoning = false
local api = vim.api

---Add a message directly to the chat buffer. This will be visible to the user
---@param chat CodeCompanion.Chat
---@param data table
---@param opts? table
local function add_buf_message(chat, data, opts)
  assert(type(data) == "table", "data must be a table")
  if data.role == config.constants.SYSTEM_ROLE then
    return
  end

  local lines = {}
  local bufnr = chat.bufnr
  local new_response = false

  local function write(text)
    for _, t in ipairs(vim.split(text, "\n", { plain = true, trimempty = false })) do
      table.insert(lines, t)
    end
  end

  -- Add a new header to the chat buffer
  local function new_role()
    new_response = true
    chat.last_role = data.role
    table.insert(lines, "")
    table.insert(lines, "")
    chat.ui:set_header(lines, config.strategies.chat.roles[data.role])
  end

  -- Add data to the chat buffer
  local function append_data()
    if data.reasoning then
      if not has_been_reasoning then
        table.insert(lines, "### Reasoning")
        table.insert(lines, "")
      end
      has_been_reasoning = true
      write(data.reasoning)
    end
    if data.content then
      if has_been_reasoning then
        has_been_reasoning = false
        table.insert(lines, "")
        table.insert(lines, "")
        table.insert(lines, "### Response")
        table.insert(lines, "")
      end
      write(data.content)
    end
  end

  local function update_buffer()
    chat.ui:unlock_buf()
    local last_line, last_column, line_count = chat.ui:last()
    if opts and opts.insert_at then
      last_line = opts.insert_at
      last_column = 0
    end

    local cursor_moved = api.nvim_win_get_cursor(0)[1] == line_count
    api.nvim_buf_set_text(bufnr, last_line, last_column, last_line, last_column, lines)

    if new_response then
      chat.ui:render_headers()
    end

    if chat.last_role ~= config.constants.USER_ROLE then
      chat.ui:lock_buf()
    end

    if config.display.chat.auto_scroll then
      if cursor_moved and chat.ui:is_active() then
        chat.ui:follow()
      elseif not chat.ui:is_active() then
        chat.ui:follow()
      end
    end
  end

  -- Handle a new role
  if (data.role and data.role ~= chat.last_role) or (opts and opts.force_role) then
    new_role()
  end

  -- Append the output from the LLM
  if data.content or data.reasoning then
    append_data()
    update_buffer()
  end
end

---Reset the chat buffer from messages
---@param chat CodeCompanion.Chat
---@param messages table[]
return function(chat, messages)
  -- Clear current chat messages
  chat.messages = {}

  -- Restore messages exactly as they were dumped
  chat.messages = vim.deepcopy(messages)
  -- cycle <- the cycle of latest message
  chat.cycle = #messages > 0 and messages[#messages].cycle + 1 or 1

  vim.api.nvim_buf_set_lines(chat.bufnr, 3, -1, false, {})

  add_buf_message(chat, { role = config.constants.USER_ROLE, content = "" })

  for _, message in ipairs(messages) do
    add_buf_message(chat, message)
  end

  add_buf_message(chat, { role = config.constants.USER_ROLE, content = "" })
  chat:set_range(-2)
  chat.status = config.constants.SUCCESS_STATUS
end
