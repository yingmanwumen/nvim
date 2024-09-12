local default_on_attach = require("plugins.lsp.nvim-lspconfig.on_attach")

vim.g.rustfmt_autosave = 1
vim.g.rustaceanvim = {
  tools = {},
  server = {
    on_attach = function(_, bufnr)
      default_on_attach(nil, bufnr)
    end,
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
        },
      },
    },
  },
}

return {
  "mrcjkb/rustaceanvim",
  ft = "rust",
  version = "^5", -- Recommended
}
