return {
  "ryleelyman/latex.nvim",
  ft = { "tex", "latex" },
  config = function()
    require("latex").setup()
  end,
}
