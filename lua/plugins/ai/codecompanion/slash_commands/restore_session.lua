local util = require("codecompanion.utils")

---@param chat CodeCompanion.Chat
---@param messages table[]
local function restore_messages(chat, messages)
  -- Clear current chat messages
  chat.messages = {}

  -- Restore messages exactly as they were dumped
  chat.messages = vim.deepcopy(messages)
  -- TODO: also restore markdown rendering
  -- chat.bufnr
end

---@param file_path string
---@return boolean, table|string
local function load_session(file_path)
  local success, result = pcall(function()
    local chunk = assert(loadfile(file_path))
    local data = chunk()
    if not data or not data.messages then
      error("Invalid session file format")
    end
    return data
  end)
  return success, result
end

---Show file picker using telescope
---@param chat CodeCompanion.Chat
local function show_picker(chat)
  local has_telescope, _ = pcall(require, "telescope")
  if not has_telescope then
    util.notify("Telescope is required for file picker", vim.log.levels.ERROR)
    return
  end
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local previewers = require("telescope.previewers")

  local dump_dir = vim.fn.stdpath("data") .. "/codecompanion/dumps"
  vim.fn.mkdir(dump_dir, "p")
  local files = vim.fn.globpath(dump_dir, "*.lua", false, true)

  if #files == 0 then
    util.notify("No session files found", vim.log.levels.WARN)
    return
  end

  pickers
    .new({
      layout_strategy = "vertical",
      layout_config = {
        height = 0.8,
        preview_height = 0.6,
      },
    }, {
      prompt_title = "Select session to restore",
      finder = finders.new_table({
        results = files,
        entry_maker = function(file)
          -- Get file content for searching
          local content = vim.fn.readfile(file)
          content = table.concat(content, " ")

          -- Load file for display
          local success, result = load_session(file)
          if not success then
            return nil
          end
          local name = vim.fn.fnamemodify(file, ":t:r"):gsub("^chat_", "")

          -- Create display lines for preview
          local msg_previews = {}

          -- Process messages for preview - show ALL messages including invisible ones
          for i, msg in ipairs(result.messages) do
            -- Create preview
            local preview = msg.content:gsub("\n", " "):sub(1, 100)
            if #msg.content > 100 then
              preview = preview .. "..."
            end
            local role_display = msg.role
            if msg.opts and msg.opts.visible == false then
              role_display = role_display .. " [hidden]"
            end
            table.insert(msg_previews, string.format("%d. %s: %s", i, role_display, preview))
          end

          return {
            value = file,
            display = string.format("%s (%s)", name, result.timestamp or "unknown time"),
            ordinal = content,
            filename = name,
            timestamp = result.timestamp or "unknown time",
            messages = result.messages,
            previews = msg_previews,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = previewers.new_buffer_previewer({
        title = "Session Preview",
        define_preview = function(self, entry)
          local lines = {}
          -- Display file info
          table.insert(lines, string.format("# %s", entry.filename))
          table.insert(lines, string.format("Saved at: %s", entry.timestamp))
          table.insert(lines, "")
          table.insert(lines, string.format("Messages (%d):", #entry.messages))
          table.insert(lines, string.rep("-", 40))

          -- Use cached previews
          vim.list_extend(lines, entry.previews)

          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          vim.api.nvim_set_option_value("filetype", "markdown", { buf = self.state.bufnr })
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if not selection then
            return
          end

          restore_messages(chat, selection.messages)
          util.notify(string.format("Session restored from: %s", vim.fn.fnamemodify(selection.value, ":~")))
        end)
        return true
      end,
    })
    :find()
end

---@param chat CodeCompanion.Chat
---@param args string|nil Optional filename
local function callback(chat, args)
  local dump_dir = vim.fn.stdpath("data") .. "/codecompanion/dumps"

  if args and args ~= "" then
    -- Direct file mode
    local file_path = string.format("%s/%s.lua", dump_dir, args)
    local success, result = load_session(file_path)

    if not success then
      util.notify(string.format("Failed to restore session: %s", result), vim.log.levels.ERROR)
      return
    end

    restore_messages(chat, result.messages)
    util.notify(string.format("Session restored from: %s", vim.fn.fnamemodify(file_path, ":~")))
  else
    -- Show file picker
    show_picker(chat)
  end
end

return {
  description = "Restore session from a dump file",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
