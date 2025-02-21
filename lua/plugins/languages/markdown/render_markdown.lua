return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = {
      "Avante",
      "codecompanion",
      "markdown",
    },

    render_modes = true,

    quote = { repeat_linebreak = true },
    win_options = {
      showbreak = { default = "", rendered = "  " },
      breakindent = { default = false, rendered = true },
      breakindentopt = { default = "", rendered = "" },
    },

    checkbox = {
      checked = { scope_highlight = "@markup.strikethrough" },
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
