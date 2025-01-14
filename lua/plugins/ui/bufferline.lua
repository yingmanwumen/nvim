return {
  "akinsho/bufferline.nvim",
  event = { "VeryLazy" },
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = {
    { "<M-1>", "<Cmd>BufferLineGoToBuffer 1<CR>" },
    { "<M-2>", "<Cmd>BufferLineGoToBuffer 2<CR>" },
    { "<M-3>", "<Cmd>BufferLineGoToBuffer 3<CR>" },
    { "<M-4>", "<Cmd>BufferLineGoToBuffer 4<CR>" },
    { "<M-5>", "<Cmd>BufferLineGoToBuffer 5<CR>" },
    { "<M-6>", "<Cmd>BufferLineGoToBuffer 6<CR>" },
    { "<M-7>", "<Cmd>BufferLineGoToBuffer 7<CR>" },
    { "<M-8>", "<Cmd>BufferLineGoToBuffer 8<CR>" },
    { "<M-9>", "<Cmd>BufferLineGoToBuffer 9<CR>" },
    { "<M-Left>", "<Cmd>BufferLineCyclePrev<CR>" },
    { "<M-Right>", "<Cmd>BufferLineCycleNext<CR>" },
  },
  config = function()
    require("bufferline").setup({
      options = {
        always_show_bufferline = false,
        separator_style = "slant",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
      },
    })
  end,
}
