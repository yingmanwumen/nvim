local this = {}

function this.module_list()
  local modules = {}
  local current_file = debug.getinfo(2, "S").source:sub(2)
  local current_dir = current_file:match("(.*/)")
  local config_dir = vim.fn.stdpath("config")
  local prefix = config_dir .. "/lua/"
  local postfix = ".lua"

  for node, _ in vim.fs.dir(current_dir) do
    if node ~= "." and node ~= ".." and node ~= "init.lua" then
      local file = current_dir .. node
      if file:sub(1, #prefix) == prefix then
        file = file:sub(#prefix + 1)
        if file:sub(-#postfix) == postfix then
          file = file:sub(1, -(#postfix + 1))
        end
        local module = file:gsub("/", ".")
        modules[#modules + 1] = require(module)
      end
    end
  end
  return modules
end

function this.autosave(bufnr)
  if bufnr == nil then
    bufnr = vim.api.nvim_get_current_buf()
  end
  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    buffer = bufnr,
    callback = function()
      if vim.bo.buftype == "" and vim.bo.readonly == false then
        vim.cmd([[write]])
      end
    end,
  })
end

function this.set_timer(interval, callback)
  local timer = vim.uv.new_timer()
  -- run interval
  timer:start(interval, interval, function()
    vim.schedule(callback)
  end)
  return timer
end

function this.clear_timer(timer)
  timer:stop()
  timer:close()
end

return this
