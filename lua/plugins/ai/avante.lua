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
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    "MeanderingProgrammer/render-markdown.nvim",
  },
  opts = {
    provider = "copilot",
    behaviour = {
      support_paste_from_clipboard = true,
    },
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
        temperature = 0.1,
        -- optional
        api_key_name = "DEEPSEEK_API_KEY",
      },
    },
    copilot = {
      model = "claude-3.5-sonnet",
      temperature = 0.1,
    },
    gemini = {
      temperature = 0.1,
    },
    windows = {
      sidebar_header = {
        enabled = false,
      },
    },
  },
}
