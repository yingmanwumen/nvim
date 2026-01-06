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
      desc = "Incoming calls",
      silent = true,
    },
    {
      "<leader>o",
      "<Cmd>Namu call out<CR>",
      desc = "Outgoing calls",
      silent = true,
    },
  },
  config = function()
    require("namu").setup({})
  end,
}
