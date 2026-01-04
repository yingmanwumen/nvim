local misc = require("misc")

local function setup()
  vim.cmd([[setlocal shiftwidth=2]])
  misc.autosave()
  -- vim.wo.number = false
  -- vim.wo.conceallevel = 3
  -- vim.wo.concealcursor = ""
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = setup,
})

local modules = require("misc").module_list()
return modules
