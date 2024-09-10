return {
  "chrisgrieser/nvim-origami",
  event = "BufReadPost",
  config = function()
    require("origami").setup({})
  end,
}
