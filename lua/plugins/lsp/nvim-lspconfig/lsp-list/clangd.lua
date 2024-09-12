return {
  lsp = "clangd",
  opts = {
    settings = {
      clangd = {
        arguments = {
          "--all-scopes-completion",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--fallback-style=google",
          "--function-arg-placeholders",
        },
      },
    },
  },
}
