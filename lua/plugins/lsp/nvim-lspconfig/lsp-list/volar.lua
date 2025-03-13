return {
  lsp = "volar",
  opts = {
    -- filetypes = { "typescript", "javascript", "vue" },
    init_options = {
      vue = {
        hybridMode = false,
      },
      typescript = {
        tsdk = os.getenv("HOME")
          .. "/.nvm/versions/node/"
          .. vim.fn.system("node -v"):gsub("\n", "")
          .. "/lib/node_modules/typescript/lib",
      },
    },
  },
}
