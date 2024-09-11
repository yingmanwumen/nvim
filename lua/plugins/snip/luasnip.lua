return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load()

    local function bind(lhs, rhs, desc)
      vim.keymap.set({ "i", "s" }, lhs, rhs, { desc = desc, silent = true })
    end
    local ls = require("luasnip")

    bind("<C-j>", function()
      return ls.jumpable(1) and "<Plug>luasnip-jump-next" or "<C-j>"
    end, "luasnip jump next")
    bind("<C-k>", function()
      return ls.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<C-k>"
    end, "luasnip jump prev")
  end,

  dependencies = {
    "honza/vim-snippets",
    "rafamadriz/friendly-snippets",
  },
}
