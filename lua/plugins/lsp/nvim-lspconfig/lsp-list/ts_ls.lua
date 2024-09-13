return {
  lsp = "ts_ls",
  opts = {
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = { enabled = true },
          includeInlayFunctionLikeReturnTypeHints = { enabled = true },
          includeInlayParameterNameHints = { enabled = "all" },
          includeInlayParameterTypeHints = { enabled = true },
          includeInlayPropertyDeclarationTypeHints = { enabled = true },
          includeInlayVariableTypeHints = { enabled = true },
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = { enabled = true },
          includeInlayFunctionLikeReturnTypeHints = { enabled = true },
          includeInlayParameterNameHints = { enabled = "all" },
          includeInlayParameterTypeHints = { enabled = true },
          includeInlayPropertyDeclarationTypeHints = { enabled = true },
          includeInlayVariableTypeHints = { enabled = true },
        },
      },
    },
  },
}
