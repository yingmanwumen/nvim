local function setup()
  local languages = require("plugins.lsp.nvim-lspconfig.lsp-list")
  local configs = require("lspconfig.configs")

  for _, language in pairs(languages) do
    if (not configs[language.lsp]) and language.config ~= nil then
      configs[language.lsp] = {
        default_config = language.config,
      }
    end
    if language.opts ~= nil then
      vim.lsp.config(language.lsp, language.opts)
      if language.enable == nil then
        language.enable = true
      end
      if language.enable ~= false then
        vim.lsp.enable(language.lsp)
      end
    end
  end

  vim.lsp.inlay_hint.enable(true)
  vim.lsp.semantic_tokens.enable(true)
  vim.lsp.inline_completion.enable(true)
  vim.lsp.document_color.enable(true)
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    -- neoconf.nvim should run before lspconfig
    "folke/neoconf.nvim",
  },
  event = "VeryLazy",
  config = setup,
}
