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

return this
