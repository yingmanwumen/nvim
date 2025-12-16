-- lua/plugins/ai/codecompanion/fidget-spinner.lua

-- This module manages fidget spinner progress indicators for CodeCompanion requests.

local progress = require("fidget.progress")

local M = {}

-- Initializes the fidget spinner module by setting up autocommands.
function M:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

  -- Autocommand to handle when a CodeCompanion request starts.
  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      if not request.data.interaction then
        return
      end
      local handle = M:create_progress_handle(request) -- Create progress handle for the request
      M:store_progress_handle(request.data.id, handle) -- Store the progress handle
    end,
  })

  -- Autocommand to handle when a CodeCompanion request finishes.
  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local handle, duration = M:pop_progress_handle(request.data.id) -- Pop the progress handle and get duration
      if handle then
        M:report_exit_status(handle, request, duration) -- Report the exit status of the request
        handle:finish() -- Finish the progress handle
      end
    end,
  })
end

-- Table to store progress handles, indexed by request ID.
M.handles = {}
-- Table to store start times of requests, indexed by request ID.
M.start_times = {}

-- Stores a progress handle and the start time for a given request ID.
function M:store_progress_handle(id, handle)
  M.handles[id] = handle -- Store handle with request ID
  M.start_times[id] = vim.uv.hrtime() -- Record start time
end

-- Pops (removes and returns) a progress handle and calculates the duration of the request.
function M:pop_progress_handle(id)
  local handle = M.handles[id] -- Get handle from stored handles
  local start_time = M.start_times[id] -- Get start time from stored start times
  M.handles[id] = nil -- Remove handle after popping
  M.start_times[id] = nil -- Remove start time after popping

  local duration = nil
  if start_time then
    local elapsed_ns = vim.uv.hrtime() - start_time
    duration = string.format("%.2fs", elapsed_ns / 1e9) -- Calculate duration in seconds
  end

  return handle, duration
end

-- Creates a progress handle with a dynamic title based on the request interaction and adapter.
function M:create_progress_handle(request)
  return progress.handle.create({
    title = " Requesting assistance (" .. request.data.interaction .. ")", -- Title includes interaction
    message = "In progress...",
    lsp_client = {
      name = M:llm_role_title(request.data.adapter), -- LSP client name based on adapter
    },
  })
end

-- Generates a formatted title for the LSP client based on the adapter information.
function M:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name) -- Insert formatted adapter name
  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")") -- Insert model name if available
  end
  return table.concat(parts, " ") -- Concatenate parts to create title
end

-- Reports the exit status of a request to the progress handle, including duration if available.
function M:report_exit_status(handle, request, duration)
  local message = ""

  if request.data.status == "success" then
    message = "Completed"
  elseif request.data.status == "error" then
    message = " Error"
  else
    message = "󰜺 Cancelled"
  end

  if duration then
    message = message .. " (" .. duration .. ")" -- Append duration to message if available
  end

  handle.message = message -- Update progress handle message
end

return M
