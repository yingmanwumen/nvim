return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = {
      "Avante",
      "markdown",
    },

    render_modes = true,

    code = {
      render_modes = true,
      border = "thick",
    },
    quote = {
      repeat_linebreak = true,
      icon = "┃",
    },
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
    "markdown",
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
  end,
}
