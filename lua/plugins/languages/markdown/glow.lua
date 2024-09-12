return {
  "ellisonleao/glow.nvim",
  ft = "markdown",
  config = function()
    require("glow").setup({})
    vim.keymap.set("n", "<leader>g", "<Cmd>Glow<CR>")
  end,
}
