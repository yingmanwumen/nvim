local default_on_attach = require("plugins.lsp.nvim-lspconfig.on_attach")

-- vim.g.rustfmt_autosave = 1

vim.g.rustaceanvim = {
  tools = {
    hover_actions = {
      replace_builtin_hover = false,
    },
  },
  server = {
    on_attach = function(client, bufnr)
      default_on_attach(client, {
        format_on_save = true,
      }, bufnr)
    end,
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        lens = {
          implementations = { enable = true },
          references = {
            adt = { enable = true },
            enumVariant = { enable = true },
            method = { enable = true },
            trait = { enable = true },
          },
          location = "above_whole_item",
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
