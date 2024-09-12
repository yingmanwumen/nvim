local default_on_attach = require("plugins.lsp.nvim-lspconfig.on_attach")

vim.g.rustfmt_autosave = 1

vim.g.rustaceanvim = {
  tools = {
    hover_actions = {
      replace_builtin_hover = false,
    },
  },
  server = {
    on_attach = function(client, bufnr)
      default_on_attach(client, nil, bufnr)
    end,
    settings = {
      ["rust-analyzer"] = {
        check = { command = "clippy" },
        lens = {
          implementations = { enable = false },
          run = { enable = false },
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
