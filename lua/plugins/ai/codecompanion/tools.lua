return {
  -- ["mcp"] = {
  --   callback = require("mcphub.extensions.codecompanion"),
  --   description = "Call tools and resources from the MCP Servers",
  --   opts = {
  --     requires_approval = true,
  --   },
  -- },

  opts = {
    system_prompt = string.format([[]]),
    auto_submit_success = true,
    auto_submit_errors = true,
  },
}