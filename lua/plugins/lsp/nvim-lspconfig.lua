
local function setup()
  local languages = require("plugins.lsp.languages")
  local lspconfig = require("lspconfig")
  for _, language in pairs(languages) do
    lspconfig[language.lsp].setup(language.opts)
  end
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  event = { "BufReadPost", "BufNewFile", },
  config = setup,
}
