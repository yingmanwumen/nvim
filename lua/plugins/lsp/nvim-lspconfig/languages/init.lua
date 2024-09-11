-- languages that are configured by nvim-lspconfig
local lsp_list = require("utils").module_list()

local function keymap(bufnr)
  local function bind(lhs, rhs, desc, mode)
    if mode == nil then
      mode = "n"
    end
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      desc = desc,
      silent = true,
    })
  end

  bind("<leader>rn", vim.lsp.buf.rename, "Rename")
  -- TODO: references, implementations, incoming calls, outgoing calls, codelens
end

local function format_on_save(bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("AutoFormat", { clear = false }),
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end,
  })
end

local function common_on_attach(lsp, bufnr)
  if lsp.format_on_save then
    format_on_save(bufnr)
  end
  keymap(bufnr)
end

local function default_on_attach(lsp)
  local on_attach = lsp.opts.on_attach
  lsp.opts["on_attach"] = function(_, bufnr)
    if on_attach ~= nil then
      on_attach(_, bufnr)
    end
    common_on_attach(lsp, bufnr)
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
