return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {
    jump = {
      jumplist = true, -- add an entry to the jumplist
    },
    signs = {
      enabled = true, -- enable signs by default
      icon = " ",
    },
    nes = {
      -- Using copilot-lsp currently
      enabled = true,
      ---@class sidekick.diff.Opts
      ---@field inline? "words"|"chars"|false Enable inline diffs
      diff = {
        inline = false,
      },
      debounce = 250,
      trigger = {
        -- events that trigger sidekick next edit suggestions
        -- currently won't be triggered in insert mode
        -- * `ModeChanged i:n` is triggered when entering normal mode from insert mode
        -- * `TextChanged` is triggered when the text is changed
        -- * `InsertLeave` is triggered when leaving insert mode
        -- * `User SidekickNesDone` is triggered when the user has finished their edit
        -- * `BufWritePost` is triggered when the file is saved
        events = {
          "ModeChanged i:n",
          "TextChanged",
          "InsertLeave",
          "User SidekickNesDone",
          "BufWritePost",
          "CursorMoved",
        },
      },
      clear = {
        -- events that clear the current next edit suggestion
        -- * `TextChangedI` is triggered when the text is changed in insert mode
        -- * `InsertEnter` is triggered when entering insert mode
        -- * `CursorMovedI` is triggered when the cursor is moved in insert mode
        -- * `BufWritePre` is triggered when the file is saved
        events = {
          "InsertEnter",
          "CursorMovedI",
          "TextChangedI",
          "BufWritePre",
        },
        esc = true, -- clear next edit suggestions when pressing <Esc>
      },
    },
    cli = {
      watch = true, -- notify Neovim of file changes done by AI CLI tools
      ---@class sidekick.win.Opts
      win = {
        --- This is run when a new terminal is created, before starting it.
        --- Here you can change window options `terminal.opts`.
        ---@param terminal sidekick.cli.Terminal
        config = function(terminal) end,
        wo = {}, ---@type vim.wo
        bo = {}, ---@type vim.bo
        layout = "right", ---@type "float"|"left"|"bottom"|"top"|"right"
        --- Options used when layout is "float"
        ---@type vim.api.keyset.win_config
        float = {
          width = 0.9,
          height = 0.9,
        },
        -- Options used when layout is "left"|"bottom"|"top"|"right"
        ---@type vim.api.keyset.win_config
        split = {
          width = 0.4, -- set to 0 for default split width
          -- width = 80, -- set to 0 for default split width
          -- height = 20, -- set to 0 for default split height
        },
        --- CLI Tool Keymaps (default mode is `t`)
        ---@type table<string, sidekick.cli.Keymap|false>
        keys = {
          -- buffers = { "<c-b>", "buffers", mode = "nt", desc = "open buffer picker" },
          -- files = { "<c-f>", "files", mode = "nt", desc = "open file picker" },
          -- hide_ctrl_dot = { "<c-.>", "hide", mode = "nt", desc = "hide the terminal window" },
          -- hide_ctrl_q = { "<c-q>", "hide", mode = "n", desc = "hide the terminal window" },
          -- hide_ctrl_z = { "<c-z>", "hide", mode = "nt", desc = "hide the terminal window" },
          -- nav_down = { "<c-j>", "nav_down", expr = true, desc = "navigate to the below window" },
          -- nav_left = { "<c-h>", "nav_left", expr = true, desc = "navigate to the left window" },
          -- nav_right = { "<c-l>", "nav_right", expr = true, desc = "navigate to the right window" },
          -- nav_up = { "<c-k>", "nav_up", expr = true, desc = "navigate to the above window" },
          -- prompt = { "<c-p>", "prompt", mode = "t", desc = "insert prompt or context" },
          buffers = { "<c-s-b>", "buffers", mode = "nt", desc = "open buffer picker" },
          files = { "<c-s-f>", "files", mode = "nt", desc = "open file picker" },
          hide_ctrl_dot = { "<c-s-.>", "hide", mode = "nt", desc = "hide the terminal window" },
          hide_ctrl_q = { "<c-s-q>", "hide", mode = "n", desc = "hide the terminal window" },
          hide_ctrl_z = { "<c-s-z>", "hide", mode = "nt", desc = "hide the terminal window" },
          nav_down = { "<c-s-j>", "nav_down", expr = true, desc = "navigate to the below window" },
          nav_left = { "<c-s-h>", "nav_left", expr = true, desc = "navigate to the left window" },
          nav_right = { "<c-s-l>", "nav_right", expr = true, desc = "navigate to the right window" },
          nav_up = { "<c-s-k>", "nav_up", expr = true, desc = "navigate to the above window" },
          prompt = { "<c-s-p>", "prompt", mode = "t", desc = "insert prompt or context" },
          hide_n = { "q", "hide", mode = "n", desc = "hide the terminal window" },
          stopinsert = { "<Esc>", "stopinsert", mode = "t", desc = "enter normal mode" },
        },
        ---@type fun(dir:"h"|"j"|"k"|"l")?
        --- Function that handles navigation between windows.
        --- Defaults to `vim.cmd.wincmd`. Used by the `nav_*` keymaps.
        nav = nil,
      },
      ---@class sidekick.cli.Mux
      ---@field backend? "tmux"|"zellij" Multiplexer backend to persist CLI sessions
      mux = {
        backend = "zellij", -- default to tmux unless zellij is detected
        enabled = false,
        -- terminal: new sessions will be created for each CLI tool and shown in a Neovim terminal
        -- window: when run inside a terminal multiplexer, new sessions will be created in a new tab
        -- split: when run inside a terminal multiplexer, new sessions will be created in a new split
        -- NOTE: zellij only supports `terminal`
        create = "terminal", ---@type "terminal"|"window"|"split"
        split = {
          vertical = true, -- vertical or horizontal split
          size = 0.5, -- size of the split (0-1 for percentage)
        },
      },
      ---@type table<string, sidekick.cli.Config|{}>
      tools = {
        aider = { cmd = { "aider", "--model", "gemini/gemini-2.5-flash" } },
        aider_insnap = {
          cmd = { "aider", "--model", "openai/gemini-2.5-flash" },
          env = {
            OPENAI_API_BASE = "https://147ai.com/v1/",
            AIDER_OPENAI_API_BASE = "https://147ai.com/v1/",
            OPENAI_API_KEY = vim.fn.getenv("INSNAP_API_KEY"),
            AIDER_OPENAI_API_KEY = vim.fn.getenv("INSNAP_API_KEY"),
          },
        },
        amazon_q = { cmd = { "q" } },
        claude = { cmd = { "claude" } },
        codex = { cmd = { "codex", "--enable", "web_search_request" } },
        copilot = { cmd = { "copilot", "--banner", "--model", "gpt-4.1" } },
        crush = {
          cmd = { "crush" },
          -- crush uses <a-p> for its own functionality, so we override the default
          keys = { prompt = { "<a-p>", "prompt" } },
        },
        cursor = { cmd = { "cursor-agent" } },
        gemini = { cmd = { "gemini", "--model", "gemini-2.5-flash" } },
        gemini_insnap = {
          cmd = { "gemini", "--model", "gemini-2.5-flash" },
          env = {
            GOOGLE_GEMINI_BASE_URL = "https://147ai.com/v1/",
            GEMINI_API_KEY = vim.fn.getenv("INSNAP_API_KEY"),
          },
        },
        grok = { cmd = { "grok" } },
        opencode = {
          cmd = { "opencode" },
          -- HACK: https://github.com/sst/opencode/issues/445
          env = { OPENCODE_THEME = "system" },
        },
        qwen = {
          cmd = { "qwen" },
          env = {
            OPENAI_API_KEY = vim.fn.getenv("GEMINI_API_KEY"),
            OPENAI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/openai/",
            OPENAI_MODEL = "gemini-2.5-flash",
          },
        },
        qwen_insnap = {
          cmd = { "qwen" },
          env = {
            OPENAI_API_KEY = vim.fn.getenv("INSNAP_API_KEY"),
            OPENAI_BASE_URL = "https://147ai.com/v1/",
            OPENAI_MODEL = "gemini-2.5-flash",
          },
        },
      },
      --- Add custom context. See `lua/sidekick/context/init.lua`
      ---@type table<string, sidekick.context.Fn>
      context = {},
      ---@type table<string, sidekick.Prompt|string|fun(ctx:sidekick.context.ctx):(string?)>
      prompts = {
        changes = "Can you review my changes?",
        diagnostics = "Can you help me fix the diagnostics in {file}?\n{diagnostics}",
        diagnostics_all = "Can you help me fix these diagnostics?\n{diagnostics_all}",
        document = "Add documentation to {function|line}",
        explain = "Explain {this}",
        fix = "Can you fix {this}?",
        optimize = "How can {this} be optimized?",
        review = "Can you review {file} for any issues or improvements?",
        tests = "Can you write tests for {this}?",
        -- simple context prompts
        buffers = "{buffers}",
        file = "{file}",
        line = "{line}",
        position = "{position}",
        quickfix = "{quickfix}",
        selection = "{selection}",
        ["function"] = "{function}",
        class = "{class}",
      },
      -- preferred picker for selecting files
      ---@alias sidekick.picker "snacks"|"telescope"|"fzf-lua"
      picker = "snacks", ---@type sidekick.picker
    },
    copilot = {
      -- track copilot's status with `didChangeStatus`
      status = {
        enabled = true,
        level = vim.log.levels.WARN,
        -- set to vim.log.levels.OFF to disable notifications
        -- level = vim.log.levels.OFF,
      },
    },
    ui = {
      icons = {
        attached = " ",
        started = " ",
        installed = " ",
        missing = " ",
        external_attached = "󰖩 ",
        external_started = "󰖪 ",
        terminal_attached = " ",
        terminal_started = " ",
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if require("sidekick").nes_jump_or_apply() then
          return -- jumped or applied
        end

        -- This api is only available in neovim >= 0.12
        -- if you are using Neovim's native inline completions
        -- if vim.lsp.inline_completion.get() then
        --   return
        -- end

        -- Call codeium#Accept() if Codeium is enabled
        -- if vim.g.codeium_server_started then
        --   return vim.fn["codeium#Accept"]()
        -- end

        -- fall back to normal tab
        return "<tab>"
      end,
      -- mode = { "i", "n" },
      mode = { "n" },
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      mode = { "n" },
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
