return {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  keys = {
    { "<C-`>", "<Cmd>ToggleTerm<CR>", mode = { "n", "i", "t" } },
    { "<M-=>", "<Cmd>ToggleTerm direction=float<CR>", mode = { "n", "i" } },
    { "<M-->", "<Cmd>ToggleTerm direction=float<CR>", mode = { "t" } },
  },
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return vim.o.lines * 0.4
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      shade_terminals = false,
      float_opts = {
        border = "curved",
      },
    })
  end,
}
