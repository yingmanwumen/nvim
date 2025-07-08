return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason-org/mason.nvim",
  },
  config = function()
    require("mason-lspconfig").setup({
      automatic_enable = false,
    })
  end,
}
