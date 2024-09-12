-- languages that are configured by nvim-lspconfig
local common_on_attach = require("plugins.lsp.nvim-lspconfig.on_attach")
local lsp_list = require("utils").module_list()

local function default_on_attach(lsp)
  local on_attach = lsp.opts.on_attach
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
    if lsp.opts.disable_default_on_attach ~= true then
      default_on_attach(lsp)
    end
  end
  res[#res + 1] = lsp
end

return lsp_list
