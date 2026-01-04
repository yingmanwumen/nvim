return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  cmd = "Copilot",
  dependencies = {
    -- "copilotlsp-nvim/copilot-lsp",
  },
  config = function()
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
      nes = {
        enabled = false,
        keymap = {
          accept_and_goto = "<tab>",
          accept = false,
          dismiss = "<Esc>",
        },
      },
    })
  end,
}
