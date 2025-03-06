return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
  },
  build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
  cmd = {
    "MCPHub",
  },
  config = function()
    local config_dir = "~/.config/nvim/config/"
    local base_conf = vim.fn.expand(config_dir .. "base-mcpservers.json")
    local conf = vim.fn.expand(config_dir .. "mcpservers.json")
    -- if conf is not present, copy base_conf to conf
    if vim.fn.filereadable(conf) == 0 then
      vim.fn.writefile(vim.fn.readfile(base_conf), conf)
    end
    require("mcphub").setup({
      -- Required options
      port = 3812, -- Port for MCP Hub server
      config = conf, -- Absolute path to config file

      -- Optional options
      on_ready = function(hub)
        -- Called when hub is ready
      end,
      on_error = function(err)
        -- Called on errors
      end,
      shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
      log = {
        level = vim.log.levels.OFF,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub",
      },
    })
  end,
}
