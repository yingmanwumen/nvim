return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = {
      "Avante",
      "codecompanion",
      "markdown",
    },
  },
  ft = {
    "Avante",
    "codecompanion",
    "markdown",
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
  end,
}
