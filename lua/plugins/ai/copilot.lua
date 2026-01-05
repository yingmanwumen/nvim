return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  cmd = "Copilot",
  dependencies = {
    -- "copilotlsp-nvim/copilot-lsp",
  },
  config = function()
    require("copilot").setup({
      suggestion = {
        -- Disable inline suggestions
        enabled = false,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = false,
        },
      },
      panel = { enabled = false },
      nes = {
        enabled = false,
        auto_trigger = true,
        keymap = {
          accept = false,
          -- accept_and_goto = "<M-l>",
          -- dismiss = "<Esc>",
        },
      },
    })
  end,
}
