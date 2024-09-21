return {
  "folke/neoconf.nvim",
  event = "VeryLazy",
  config = function()
    require("neoconf").setup()
  end,
}
