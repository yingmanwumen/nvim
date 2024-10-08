local function setup()
  local languages = require("plugins.lsp.nvim-lspconfig.lsp-list")
  local lspconfig = require("lspconfig")

  for _, language in pairs(languages) do
    -- register lsp
    if language.config ~= nil then
      vim.tbl_deep_extend("keep", lspconfig, {
        [language.lsp] = language.config,
      })
    end
    lspconfig[language.lsp].setup(language.opts)
  end

  vim.lsp.inlay_hint.enable(true)
end

local icons = require("plugins.lsp.nvim-lspconfig.icons")
for name, icon in pairs(icons) do
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- neoconf.nvim should run before lspconfig
    "folke/neoconf.nvim",
  },
  event = "VeryLazy",
  config = setup,
}
