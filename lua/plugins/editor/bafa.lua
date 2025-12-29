return {
  "mistweaverco/bafa.nvim",
  keys = {
    {
      "<M-b>",
      function()
        require("bafa.ui").toggle()
      end,
    },
  },
  config = function()
    require("bafa").setup({
      -- 🔔 Notification configuration
      notify = {
        -- Used for for feedback messages
        -- Anything that has a `vim.notify` like interface will work
        -- e.g. `juu.notify`, `telescope.notify`, etc.
        -- print is also supported,
        -- even though it's does not implement the notify interface
        provider = "vim.notify",
      },
      ui = {
        -- 🦘 Jump-labels configuration
        jump_labels = {
          -- Keys to use for jump-labels
          -- in order of preference
          -- Should be unique characters
          -- Duplicates will be ignored
          -- You can customize this to your keyboard layout
          -- will also use uppercase variants of these keys
          -- if the lower-case ones are exhausted
          -- This should give us 48 unique keys on a QWERTY layout
          -- That should be enough for most use-cases
          -- but when we run out of keys, only the first buffers (in order, from top to bottom)
          -- will get jump-labels assigned
          keys = {
            "a",
            "s",
            "d",
            "f",
            "j",
            "k",
            "l",
            ";",
            "q",
            "w",
            "e",
            "r",
            "u",
            "i",
            "o",
            "p",
            "z",
            "x",
            "c",
            "v",
            "n",
            "m",
            ",",
            ".",
          },
        },
        -- 🚨 Show diagnostics in the UI
        diagnostics = true,
        -- 📄 Show line numbers in the UI
        line_numbers = false,
        -- 👀 Title configuration
        title = {
          -- Title of the floating window
          text = "",
          -- Position of the title: "left", "center", "right"
          -- See `:h nvim_open_win` for more details
          pos = "center",
        },
        -- 🎨 Floating window border configuration
        -- Floating window border: "single", "double", "rounded", "solid", "shadow", or a table
        -- See `:h nvim_open_win` for more details on custom borders
        border = "rounded",
        -- 🎨 Floating window style configuration
        -- Floating window style: "minimal", "normal"
        -- See `:h nvim_open_win` for more details
        style = "minimal",
        -- 📏 Floating window alignment configuration
        position = {
          -- Window position preset:
          -- "center", "top-center", "bottom-center", "top-left", "top-right",
          -- "bottom-left", "bottom-right", "center-left", "center-right"
          preset = "center",
          -- Custom row position (overrides preset if set)
          -- also supports a function that returns a number
          row = nil,
          -- Custom column position (overrides preset if set)
          -- also supports a function that returns a number
          col = nil,
        },
        -- 💄 Icons configuration
        icons = {
          -- 🚨 Diagnostics icons configuration
          diagnostics = {
            Error = "", -- Icon for error diagnostics
            Warn = "", -- Icon for warning diagnostics
            Info = "", -- Icon for info diagnostics
            Hint = "", -- Icon for hint diagnostics
          },
          -- 🖊️ Buffer changes sign configuration
          sign = {
            changes = "┃", -- Sign character for modified/deleted buffers
          },
        },
        -- 🎨 Highlight groups configuration
        hl = {
          -- 🖊️ Buffer changes sign highlight groups configuration
          sign = {
            modified = "GitSignsChange", -- Highlight group for modified buffer signs (fallback: DiffChange)
            deleted = "GitSignsDelete", -- Highlight group for deleted buffer signs (fallback: DiffDelete)
          },
        },
      },
    })
  end,
}
