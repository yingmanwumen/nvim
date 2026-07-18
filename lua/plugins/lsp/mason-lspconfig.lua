return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason-org/mason.nvim",
  },
  config = function()
    local function get_ensure_installed()
      local languages = require("plugins.lsp.nvim-lspconfig.lsp-list")
      local lspconfig_to_package = require("mason-lspconfig").get_mappings().lspconfig_to_package
      local ensure_installed = {}

      for _, language in pairs(languages) do
        if language.auto_install ~= false and lspconfig_to_package[language.lsp] ~= nil then
          ensure_installed[#ensure_installed + 1] = language.lsp
        end
      end

      return ensure_installed
    end

    local ensure_installed = get_ensure_installed()

    require("mason-lspconfig").setup({
      automatic_enable = false,
      ensure_installed = ensure_installed,
    })
  end,
}
