return {
  "bassamsdata/namu.nvim",
  keys = {
    {
      "<leader>ss",
      function()
        require("namu.namu_symbols").show()
      end,
      desc = "Jump to LSP symbol",
      silent = true,
    },
  },
  config = function()
    require("namu").setup({})
  end,
}
