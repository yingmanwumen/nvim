return {
  "ellisonleao/glow.nvim",
  ft = "markdown",
  config = function()
    require("glow").setup({})
    vim.cmd([[
        nnoremap <leader>g <Cmd>Glow<CR>
      ]])
  end,
}
