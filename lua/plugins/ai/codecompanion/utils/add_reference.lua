local config = require("codecompanion.config")
local helpers = require("codecompanion.strategies.chat.helpers")

local user_role = config.strategies.chat.roles.user
local api = vim.api

---Add a reference to the chat buffer
---@param chat CodeCompanion.Chat
---@param ref CodeCompanion.Chat.Ref
---@param row integer
local function add(chat, ref, row)
  local lines = {}

  table.insert(lines, string.format("> - %s", ref.id))

  if vim.tbl_count(chat.refs) == 1 then
    table.insert(lines, 1, "> Sharing:")
    table.insert(lines, "")
  end

  api.nvim_buf_set_lines(chat.bufnr, row, row, false, lines)
end

---Parse the chat buffer to find where to add the references
---@param chat CodeCompanion.Chat
---@return table|nil
local function ts_parse_buffer(chat)
  local query = vim.treesitter.query.get("markdown", "reference")

  local tree = chat.parser:parse({ chat.header_line - 1, -1 })[1]
  local root = tree:root()

  -- Check if there are any references already in the chat buffer
  local refs
  for id, node in query:iter_captures(root, chat.bufnr, chat.header_line - 1, -1) do
    if query.captures[id] == "refs" then
      refs = node
    end
  end

  if refs and not vim.tbl_isempty(chat.refs) then
    local start_row, _, end_row, _ = refs:range()
    return {
      capture = "refs",
      start_row = start_row + 2,
      end_row = end_row + 1,
    }
  end

  -- If not, check if there is a heading to add the references below
  local role
  local role_node
  for id, node in query:iter_captures(root, chat.bufnr, chat.header_line - 1, -1) do
    if query.captures[id] == "role" then
      role = vim.treesitter.get_node_text(node, chat.bufnr)
      role_node = node
    end
  end

  role = helpers.format_role(role)

  if role_node and role == user_role then
    local start_row, _, end_row, _ = role_node:range()
    return {
      capture = "role",
      start_row = start_row + 1,
      end_row = end_row + 1,
    }
  end

  return nil
end

---Add a reference to the chat buffer
---@param self CodeCompanion.Chat.References
---@param ref CodeCompanion.Chat.Ref
---@return nil
local function references_add(self, ref)
  if not ref or not config.display.chat.show_references then
    return self
  end

  local existed = false
  if ref then
    if not ref.opts then
      ref.opts = {}
    end
    -- Ensure both properties exist with defaults
    ref.opts.pinned = ref.opts.pinned or false
    ref.opts.watched = ref.opts.watched or false
    -- if the reference is already existing, replace it. or insert it
    for i, existing_ref in pairs(self.Chat.refs) do
      if existing_ref.id == ref.id then
        self.Chat.refs[i] = ref
        existed = true
      end
    end
    if not existed then
      table.insert(self.Chat.refs, ref)
    end
    -- If it's a buffer reference and it's being watched, start watching
    if ref.bufnr and ref.opts.watched then
      self.Chat.watchers:watch(ref.bufnr)
    end
  end

  local parsed_buffer = ts_parse_buffer(self.Chat)

  if parsed_buffer and not existed then
    -- If the reference block already exists, add to it
    if parsed_buffer.capture == "refs" then
      add(self.Chat, ref, parsed_buffer.end_row - 1)
    -- If there are no references then add a new block below the heading
    elseif parsed_buffer.capture == "role" then
      add(self.Chat, ref, parsed_buffer.end_row + 1)
    end
  end
end

---Add a reference to the chat buffer (Useful for user's adding custom Slash Commands)
---@param chat CodeCompanion.Chat
---@param data { role: string, content: string }
---@param source string
---@param id string
---@param opts? table Options for the message
return function(chat, data, source, id, opts)
  opts = opts or { reference = id, visible = false }

  references_add(chat.references, { source = source, id = id })
  chat:add_message(data, opts)
end
