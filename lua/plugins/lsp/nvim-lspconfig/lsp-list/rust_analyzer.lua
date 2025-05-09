return {
  lsp = "rust_analyzer",
  format_on_save = true,
  opts = {
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
