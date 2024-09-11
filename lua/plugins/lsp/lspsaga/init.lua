return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
  config = function()
    require("lspsaga").setup({
      diagnostic = {},
      lightbulb = {
        enable = true,
        sign = false,
        virtual_text = true,
      },
      code_action = {
        extend_gitsigns = true,
      },
    })

    require("plugins.lsp.lspsaga.keymap")
  end,
}
