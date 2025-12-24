return {
  "bassamsdata/namu.nvim",
  keys = {
    {
      "<leader>ss",
      "<Cmd>Namu symbols<CR>",
      desc = "Jump to LSP symbol",
      silent = true,
    },
    {
      "<leader>sw",
      "<Cmd>Namu workspace<CR>",
      desc = "Jump to LSP symbol",
      silent = true,
    },
    {
      "<leader>i",
      "<Cmd>Namu call in<CR>",
      desc = "Jump to LSP symbol",
      silent = true,
    },
    {
      "<leader>o",
      "<Cmd>Namu call in<CR>",
      desc = "Jump to LSP symbol",
      silent = true,
    },
  },
  config = function()
    require("namu").setup({})
  end,
}
