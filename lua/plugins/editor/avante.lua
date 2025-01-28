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
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  opts = {
    provider = "copilot",
    -- provider = "openai",
    behaviour = {
      support_paste_from_clipboard = true,
    },
    mappings = {
      sidebar = {
        switch_windows = "<C-Tab>",
        reverse_switch_windows = "<C-S-Tab>",
      },
    },
    openai = {
      endpoint = "https://api.deepseek.com/v1",
      model = "deepseek-chat",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0.5,
      max_tokens = 4096,
      -- optional
      api_key_name = "DEEPSEEK_API_KEY", -- Default OPENAI_API_KEY if not set
    },
    windows = {
      sidebar_header = {
        enabled = false,
      },
    },
  },
}
