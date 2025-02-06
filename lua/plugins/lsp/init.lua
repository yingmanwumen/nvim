local modules = require("misc").module_list()

vim.diagnostic.config({
  virtual_text = {
    prefix = "",
  },
})

local original = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
  vim.tbl_map(function(item)
    if item.relatedInformation and #item.relatedInformation > 0 then
      vim.tbl_map(function(k)
        if k.location then
          local tail = vim.fn.fnamemodify(vim.uri_to_fname(k.location.uri), ":t")
          k.message = tail
            .. "("
            .. (k.location.range.start.line + 1)
            .. ", "
            .. (k.location.range.start.character + 1)
            .. "): "
            .. k.message
        end
        item.message = item.message .. "\n" .. k.message
      end, item.relatedInformation)
    end
  end, result.diagnostics)
  original(_, result, ctx, config)
end
return modules
