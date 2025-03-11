local util = require("codecompanion.utils")

---@param file_path string
---@return boolean, string?
local function delete_file(file_path)
  local success, err = pcall(function()
    os.remove(file_path)
  end)
  return success, err
end

---Show file picker using telescope

local function show_picker()
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
      prompt_title = "Select session to delete",
      finder = finders.new_table({
        results = files,
        entry_maker = function(file)
          -- Get file content for searching
          local content = vim.fn.readfile(file)
          content = table.concat(content, " ")

          -- Load file for display
          local success, result = pcall(function()
            local chunk = assert(loadfile(file))
            return chunk()
          end)
          if not success then
            return nil
          end
          local name = vim.fn.fnamemodify(file, ":t:r"):gsub("^chat_", "")

          -- Create display lines for preview
          local msg_previews = {}

          -- Process messages for preview
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
        title = "Session Info",
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

          table.insert(lines, "")
          table.insert(lines, "Press <Enter> to delete this session")
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          vim.bo[self.state.bufnr].filetype = "markdown"
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if not selection then
            return
          end

          -- Confirm deletion
          local confirm = vim.fn.input(string.format("Delete session '%s'? [y/N] ", selection.filename))
          if confirm:lower() ~= "y" then
            util.notify("Session deletion cancelled")
            return
          end

          local success, err = delete_file(selection.value)
          if success then
            util.notify(string.format("Session deleted: %s", vim.fn.fnamemodify(selection.value, ":~")))
          else
            util.notify(string.format("Failed to delete session: %s", err or "unknown error"), vim.log.levels.ERROR)
          end
        end)
        return true
      end,
    })
    :find()
end

---@param args string|nil Optional filename
local function callback(_, args)
  local dump_dir = vim.fn.stdpath("data") .. "/codecompanion/dumps"

  if args and args ~= "" then
    -- Direct file mode
    local file_path = string.format("%s/%s.lua", dump_dir, args)

    -- Check if file exists
    if not vim.uv.fs_stat(file_path) then
      util.notify(
        string.format("Session file not found: %s", vim.fn.fnamemodify(file_path, ":~")),
        vim.log.levels.ERROR
      )
      return
    end

    -- Confirm deletion
    local confirm = vim.fn.input(string.format("Delete session '%s'? [y/N] ", args))
    if confirm:lower() ~= "y" then
      util.notify("Session deletion cancelled")
      return
    end

    local success, err = delete_file(file_path)
    if success then
      util.notify(string.format("Session deleted: %s", vim.fn.fnamemodify(file_path, ":~")))
    else
      util.notify(string.format("Failed to delete session: %s", err or "unknown error"), vim.log.levels.ERROR)
    end
  else
    -- Show file picker
    show_picker()
  end
end

return {
  description = "Delete a saved session",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
