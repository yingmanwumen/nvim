local function setup()
  vim.cmd([[setlocal shiftwidth=4]])
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "haskell" },
  callback = setup,
})

local modules = require("misc").module_list()
return modules
