local function supports(client, method, bufnr)
  return client:supports_method(method, bufnr)
end

local function keymap(client, bufnr)
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

  if supports(client, "textDocument/rename", bufnr) then
    bind("<leader>rn", vim.lsp.buf.rename, "Rename")
  end
  -- NOTE: there are bugs with goto definition in Telescope
  --
  -- bind("gd", "<Cmd>Telescope lsp_definitions<CR>", "Goto Definition")
  if supports(client, "textDocument/definition", bufnr) then
    bind("gd", vim.lsp.buf.definition, "Goto Definition")
  end
  if supports(client, "textDocument/references", bufnr) then
    bind("gr", "<Cmd>Telescope lsp_references<CR>", "Goto References")
  end
  if supports(client, "textDocument/implementation", bufnr) then
    bind("gi", "<Cmd>Telescope lsp_implementations<CR>", "Goto Implementation")
  end
  if supports(client, "textDocument/codeAction", bufnr) then
    bind("<C-.>", vim.lsp.buf.code_action, "Code action")
    bind("g.", vim.lsp.buf.code_action, "Code action")
  end
end

local function format_on_save(client, bufnr)
  local function whole_buffer_range()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local last_line_index = math.max(#lines - 1, 0)
    local last_text = lines[last_line_index + 1] or ""
    local end_character = 0
    if #last_text > 0 then
      end_character = vim.lsp.util.character_offset(
        bufnr,
        last_line_index,
        #last_text,
        client.offset_encoding
      )
    end
    return {
      start = { line = 0, character = 0 },
      ["end"] = { line = last_line_index, character = end_character },
    }
  end

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("AutoFormat", { clear = false }),
    buffer = bufnr,
    callback = function()
      local method = nil
      if supports(client, "textDocument/formatting", bufnr) then
        method = "textDocument/formatting"
      elseif supports(client, "textDocument/rangeFormatting", bufnr) then
        method = "textDocument/rangeFormatting"
      end
      if method == nil then
        return
      end
      local format_opts = {
        bufnr = bufnr,
        filter = function(format_client)
          return format_client.id == client.id and supports(format_client, method, bufnr)
        end,
      }
      if method == "textDocument/rangeFormatting" then
        format_opts.range = whole_buffer_range()
      end
      vim.lsp.buf.format(format_opts)
    end,
  })
end

local function codelens(client, bufnr)
  if supports(client, "textDocument/codeLens", bufnr) then
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("CodeLens", { clear = false }),
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
      end,
    })
  end
end

local function on_attach(client, opts, bufnr)
  opts = opts or {}
  keymap(client, bufnr)
  codelens(client, bufnr)
  if opts.format_on_save ~= false
      and (supports(client, "textDocument/formatting", bufnr)
        or supports(client, "textDocument/rangeFormatting", bufnr)) then
    format_on_save(client, bufnr)
  end
end

return on_attach
