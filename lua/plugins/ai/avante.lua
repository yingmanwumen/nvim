-- TODO: custom prompt
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",

    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    "yingmanwumen/copilot.lua",
    "MeanderingProgrammer/render-markdown.nvim",
    "ravitemer/mcphub.nvim",
  },
  config = function()
    require("avante").setup({

      provider = "copilot",
      behaviour = {
        support_paste_from_clipboard = true,
      },
      hints = { enabled = false },
      mappings = {
        sidebar = {
          switch_windows = "<C-Tab>",
          reverse_switch_windows = "<C-S-Tab>",
        },
      },
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          endpoint = "https://api.deepseek.com/v1",
          -- model = "deepseek-chat",
          model = "deepseek-reasoner",
          temperature = 0.3,
          -- optional
          api_key_name = "DEEPSEEK_API_KEY",
        },
      },
      copilot = {
        model = "claude-3.5-sonnet",
        temperature = 0.3,
      },
      gemini = {
        temperature = 0.3,
      },
      windows = {
        sidebar_header = {
          enabled = true,
        },
        width = 45,
      },
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        ---@diagnostic disable-next-line: need-check-nil
        return hub:get_active_servers_prompt()
      end,
      custom_tools = {
        require("mcphub.extensions.avante").mcp_tool(),
      },
    })
  end,
}

-- Tool functions available:

-- File Pattern Matching
-- glob: Match files using glob patterns like "**/*.js"

-- Python Code Execution
-- python: Run python code (cannot read/modify files)

-- Git Operations
-- git_diff: Get git diff for commit message
-- git_commit: Commit changes with message

-- File System Operations
-- list_files: List files in directory
-- search_files: Search for files
-- search_keyword: Search for keyword in files
-- read_file_toplevel_symbols: Read top-level symbols
-- read_file: Read file contents

-- File/Directory Management
-- create_file: Create new file
-- rename_file: Rename file
-- delete_file: Delete file
-- create_dir: Create directory
-- rename_dir: Rename directory
-- delete_dir: Delete directory

-- Shell Commands
-- bash: Run bash command (no search/read operations)

-- Web Operations
-- web_search: Search the web
-- fetch: Get markdown from URL

-- Context Management
-- add_file_to_context: Add file to context
-- remove_file_from_context: Remove file from context
