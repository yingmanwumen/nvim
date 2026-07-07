return {
  "cursortab/cursortab.nvim",
  lazy = false, -- The server is already lazy loaded
  build = "cd server && go build",
  config = function()
    require("cursortab").setup({
      enabled = true,
      log_level = "info", -- "trace", "debug", "info", "warn", "error"
      state_dir = vim.fn.stdpath("state") .. "/cursortab", -- Directory for runtime files (log, socket, pid)
      contribute_data = false, -- Opt-in: send anonymous metrics to train a better gating model

      keymaps = {
        accept = "<Tab>", -- Keymap to accept completion, or false to disable
        partial_accept = "<S-Tab>", -- Keymap to partially accept, or false to disable
        -- partial_accept = false,
        trigger = false, -- Keymap to manually trigger completion, or false to disable
      },

      ui = {
        completions = {
          addition_style = "dimmed", -- "dimmed" or "highlight"
          fg_opacity = 0.8, -- opacity for completion overlays (0=invisible, 1=fully visible)
        },
        jump = {
          symbol = "", -- Symbol shown for jump points
          text = " TAB ", -- Text displayed after jump symbol
          show_distance = true, -- Show line distance for off-screen jumps
        },
      },

      -- behavior = {
      --   idle_completion_delay = 50, -- Delay in ms after idle to trigger completion (-1 to disable)
      --   text_change_debounce = 50, -- Debounce in ms after text change to trigger completion (-1 to disable)
      --   max_visible_lines = 12, -- Max visible lines per completion (0 to disable)
      --   disabled_in = {}, -- Tree-sitter scopes to suppress completions (e.g., { "comment", "string" })
      --   enabled_modes = { "insert", "normal" }, -- Modes where completions are active
      --   cursor_prediction = {
      --     enabled = true, -- Show jump indicators after completions
      --     auto_advance = true, -- When no changes, show cursor jump to last line
      --     proximity_threshold = 2, -- Min lines apart to show cursor jump (0 to disable)
      --   },
      --   ignore_paths = { -- Glob patterns for files to skip completions
      --     "*.min.js",
      --     "*.min.css",
      --     "*.map",
      --     "*-lock.json",
      --     "*.lock",
      --     "*.sum",
      --     "*.csv",
      --     "*.tsv",
      --     "*.parquet",
      --     "*.zip",
      --     "*.tar",
      --     "*.gz",
      --     "*.pem",
      --     "*.key",
      --     ".env",
      --     ".env.*",
      --     "*.log",
      --   },
      --   ignore_filetypes = { "", "terminal" }, -- Filetypes to skip completions
      --   ignore_gitignored = true, -- Skip files matched by .gitignore
      -- },

      provider = {
        type = "mercuryapi", -- Provider: "inline", "fim", "sweep", "zeta-2", "zeta", "copilot", "windsurf", or "mercuryapi"
        -- url = "https://api.deepseek.com/beta", -- URL of the provider server
        api_key_env = "INCEPTION_KEY", -- Env var name for API key (e.g., "OPENAI_API_KEY")
        -- model = "deepseek-v4-pro", -- Model name
        -- temperature = 0.3, -- Sampling temperature
        -- context_size = 0, -- Max input context in tokens (0 = use max_tokens; inline/fim default: 1024)
        -- max_tokens = 512, -- Max tokens to generate (inline default: 64, fim default: 128)
        -- top_k = 50, -- Top-k sampling
        -- completion_timeout = 5000, -- Timeout in ms for completion requests
        -- max_diff_history_tokens = 512, -- Max tokens for diff history (0 = no limit)
         -- completion_path = "/v1/completions", -- API endpoint path
        -- fim_tokens is optional. Omit (the default) to use OpenAI prompt+suffix
        -- format (e.g. DeepSeek). Set it to opt into tokenized FIM:
        --   fim_tokens = {
        --     prefix = "<|fim_prefix|>",
        --     suffix = "<|fim_suffix|>",
        --     middle = "<|fim_middle|>",
        --     repo_name = "<|repo_name|>",     -- optional; auto-detected for Qwen
        --     file_sep = "<|file_sep|>",       -- optional; auto-detected for Qwen
        --   },
        privacy_mode = true, -- Don't send telemetry to provider
      },

      -- blink = {
      --   enabled = false, -- Enable blink source
      --   ghost_text = true, -- Show native ghost text alongside blink menu
      -- },
      --
      -- debug = {
      --   immediate_shutdown = false, -- Shutdown daemon immediately when no clients
      -- },
    })
  end,
}
