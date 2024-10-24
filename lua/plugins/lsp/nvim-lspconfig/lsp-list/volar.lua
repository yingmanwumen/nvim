return {
  lsp = "volar",
  opts = {
    -- filetypes = { "typescript", "javascript", "vue" },
    init_options = {
      vue = {
        hybridMode = false,
      },
      typescript = {
        tsdk = os.getenv("HOME") .. "/.nvm/versions/node/v20.15.0/lib/node_modules/typescript/lib",
      },
    },
  },
}
