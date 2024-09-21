return {
  "LunarVim/bigfile.nvim",
  event = "VeryLazy",
  config = function()
    require("bigfile").setup({
      filesize = 3,
      features = {
        "lsp",
        "treesitter",
        "illuminate",
      },
    })
  end,
}
