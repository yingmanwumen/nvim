return {
  lsp = "jsonls",
  disabled_methods = {
    ["textDocument/formatting"] = true,
    ["textDocument/rangeFormatting"] = true,
  },
  opts = {},
}
