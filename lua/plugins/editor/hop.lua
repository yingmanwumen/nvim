return {
  "smoka7/hop.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader><leader>j", "<Cmd>HopLineAC<CR>", mode = { "n", "x" } },
    { "<leader><leader>k", "<Cmd>HopLineBC<CR>", mode = { "n", "x" } },
    { "<leader><leader>w", "<Cmd>HopWord<CR>", mode = { "n", "x" } },
    { "<leader><leader>s", "<Cmd>HopChar1<CR>", mode = { "n", "x" } },
    { "<leader><leader>l", "<Cmd>HopWordCurrentLineAC<CR>", mode = { "n", "x" } },
    { "<leader><leader>h", "<Cmd>HopWordCurrentLineBC<CR>", mode = { "n", "x" } },
  },
  opts = {
    keys = "etovxqpdygfblzhckisuran",
  },
}
