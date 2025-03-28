local modules = require("misc").module_list()

vim.diagnostic.config({

  -- virtual_text = {
  -- current_line = true,
  --   prefix = "",
  -- },

  virtual_lines = {
    current_line = true,
  },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

-- Override default LSP diagnostics handler to improve display of related information
-- Store the original handler for later use
local original = vim.lsp.handlers["textDocument/publishDiagnostics"]

-- Create a custom handler for diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
  -- Process each diagnostic item
  vim.tbl_map(function(item)
    -- Check if the diagnostic has related information
    if item.relatedInformation and #item.relatedInformation > 0 then
      -- Process each related information item
      vim.tbl_map(function(k)
        -- If location information is present
        if k.location then
          -- Get the filename from the URI
          local tail = vim.fn.fnamemodify(vim.uri_to_fname(k.location.uri), ":t")

          -- Format the message to include filename, line and column numbers
          -- Note: Adding 1 to line/column because LSP uses 0-based indexing
          k.message = tail
            .. "("
            .. (k.location.range.start.line + 1)
            .. ", "
            .. (k.location.range.start.character + 1)
            .. "): "
            .. k.message
        end

        -- Append the related information to the main diagnostic message
        item.message = item.message .. "\n" .. k.message
      end, item.relatedInformation)
    end
  end, result.diagnostics)

  -- Call the original handler with our modified results
  original(_, result, ctx, config)
end

-- Toggle inlay hints for the current buffer
local function toggle_inlay_hints()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })

  -- Check if there are LSP clients attached to the buffer
  if #clients == 0 then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
    return
  end

  -- Get the current state of inlay hints for this buffer
  local current_value = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })

  -- Toggle the inlay hints state
  vim.lsp.inlay_hint.enable(not current_value, { bufnr = buf })

  -- Notify the user of the new state
  if not current_value then
    vim.notify("Enabled inlay hints", vim.log.levels.INFO)
  else
    vim.notify("Disabled inlay hints", vim.log.levels.INFO)
  end
end

-- Create a user command for toggling inlay hints
vim.api.nvim_create_user_command("ToggleInlayHint", toggle_inlay_hints, {
  desc = "Toggle inlay hints for the current buffer",
})

return modules
