-- languages that are configured by nvim-lspconfig
local common_on_attach = require("plugins.lsp.nvim-lspconfig.on_attach")
local lsp_list = require("misc").module_list()

local function install_method_guard(lsp)
  local opts = lsp.opts
  local on_init = opts.on_init
  local disabled_methods = lsp.disabled_methods or {}
  opts.on_init = function(client, ...)
    local supports_method = client.supports_method
    client.supports_method = function(self, method, bufnr)
      if disabled_methods[method] == true then
        return false
      end
      return supports_method(self, method, bufnr)
    end
    if on_init ~= nil then
      return on_init(client, ...)
    end
  end
end

local function default_on_attach(lsp)
  local opts = lsp.opts or {}
  local on_attach = opts.on_attach
  lsp.opts = opts
  lsp.opts["on_attach"] = function(client, bufnr)
    if on_attach ~= nil then
      on_attach(client, bufnr)
    end
    common_on_attach(client, lsp, bufnr)
  end
end

local res = {}
for _, lsp in ipairs(lsp_list) do
  if lsp.opts ~= nil then
    install_method_guard(lsp)
    if lsp.opts.disable_default_on_attach ~= true then
      default_on_attach(lsp)
    end
  end
  res[#res + 1] = lsp
end

return lsp_list
