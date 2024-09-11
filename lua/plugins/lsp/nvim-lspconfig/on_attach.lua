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
  bind("gd", vim.lsp.buf.definition, "Rename")
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

local function on_attach(opts, bufnr)
  keymap(bufnr)
  if opts == nil then
    return
  end
  if opts.format_on_save then
    format_on_save(bufnr)
  end
end

return on_attach
