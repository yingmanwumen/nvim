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
  -- NOTE: there are bugs with goto definition in Telescope
  --
  -- bind("gd", "<Cmd>Telescope lsp_definitions<CR>", "Goto Definition")
  bind("gd", vim.lsp.buf.definition, "Goto Definition")
  bind("gr", "<Cmd>Telescope lsp_references<CR>", "Goto References")
  bind("gi", "<Cmd>Telescope lsp_implementations<CR>", "Goto Implementation")
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

local function codelens(client, bufnr)
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("CodeLens", { clear = false }),
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end,
    })
  end
end

local function on_attach(client, opts, bufnr)
  keymap(bufnr)
  codelens(client, bufnr)
  if opts == nil then
    return
  end
  if opts.format_on_save ~= nil and opts.format_on_save == true then
    format_on_save(bufnr)
  end
end

return on_attach
