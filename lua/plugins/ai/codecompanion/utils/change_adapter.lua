local config = require("codecompanion.config")
local util = require("codecompanion.utils")

return function(chat, selected_adapter, selected_model)
  local adapters = vim.deepcopy(config.adapters)
  local current_adapter = chat.adapter.name
  local current_model = vim.deepcopy(chat.adapter.schema.model.default)

  if current_adapter ~= selected_adapter then
    chat.adapter = require("codecompanion.adapters").resolve(adapters[selected_adapter])
    util.fire("ChatAdapter", {
      bufnr = chat.bufnr,
      adapter = require("codecompanion.adapters").make_safe(chat.adapter),
    })
    chat.ui.adapter = chat.adapter
    chat:apply_settings()
  end

  -- Update the system prompt
  local system_prompt = config.opts.system_prompt
  if type(system_prompt) == "function" then
    if chat.messages[1] and chat.messages[1].role == "system" then
      local opts = {
        adapter = chat.adapter,
        language = config.opts.language,
      }
      chat.messages[1].content = system_prompt(opts)
    end
  end

  if current_model ~= selected_model then
    util.fire("ChatModel", {
      bufnr = chat.bufnr,
      model = selected_model,
    })
  end

  chat:apply_model(selected_model)
  chat:apply_settings()
end
