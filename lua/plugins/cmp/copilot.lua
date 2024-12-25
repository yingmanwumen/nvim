return {
  "zbirenbaum/copilot-cmp",
  event = { "InsertEnter", "LspAttach" },
  dependencies = {
    "hrsh7th/nvim-cmp",
    "zbirenbaum/copilot.lua",
  },
  config = function()
    require("copilot_cmp").setup()
  end,
}
