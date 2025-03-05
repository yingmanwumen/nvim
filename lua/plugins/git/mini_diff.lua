return {
  "echasnovski/mini.diff",
  config = function()
    require("mini.diff").setup({
      options = {
        algorithm = "histogram",
        linematch = 120,
      },
    })
  end,
}
