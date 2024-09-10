return {
  'akinsho/toggleterm.nvim',
  cmd = "ToggleTerm",
  keys = {
    { "<C-`>", "<Cmd>ToggleTerm<CR>", mode = { "n", "i", "t" } },
    { "<M-=>", "<Cmd>ToggleTerm<CR>", mode = { "n", "i" } },
    { "<M-->", "<Cmd>ToggleTerm<CR>", mode = { "t" } },
  },
  config = function()
    require("toggleterm").setup({
      size = 25,
      shade_terminals = false,
    })
  end
}
