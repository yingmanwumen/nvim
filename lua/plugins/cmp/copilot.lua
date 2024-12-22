return {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = "hrsh7th/nvim-cmp",
  config = function()
    require("copilot_cmp").setup()
  end,
}
