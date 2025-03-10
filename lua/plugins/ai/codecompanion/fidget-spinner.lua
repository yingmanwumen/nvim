-- lua/plugins/codecompanion/fidget-spinner.lua

local progress = require("fidget.progress")

local M = {}

function M:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      if not request.data.strategy then
        return
      end
      local handle = M:create_progress_handle(request)
      M:store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local handle, duration = M:pop_progress_handle(request.data.id)
      if handle then
        M:report_exit_status(handle, request, duration)
        handle:finish()
      end
    end,
  })
end

M.handles = {}
M.start_times = {}

function M:store_progress_handle(id, handle)
  M.handles[id] = handle
  M.start_times[id] = vim.uv.hrtime()
end

function M:pop_progress_handle(id)
  local handle = M.handles[id]
  local start_time = M.start_times[id]
  M.handles[id] = nil
  M.start_times[id] = nil

  local duration = nil
  if start_time then
    local elapsed_ns = vim.uv.hrtime() - start_time
    duration = string.format("%.2fs", elapsed_ns / 1e9)
  end

  return handle, duration
end

function M:create_progress_handle(request)
  return progress.handle.create({
    title = " Requesting assistance (" .. request.data.strategy .. ")",
    message = "In progress...",
    lsp_client = {
      name = M:llm_role_title(request.data.adapter),
    },
  })
end

function M:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")")
  end
  return table.concat(parts, " ")
end

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
    message = message .. " (" .. duration .. ")"
  end

  handle.message = message
end

return M
