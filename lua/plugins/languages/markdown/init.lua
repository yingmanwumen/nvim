local utils = require("utils")

local function setup()
  vim.wo.conceallevel = 3
  vim.wo.concealcursor = ""
  utils.autosave()
  -- vim.wo.number = false
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = setup,
})

local modules = require("utils").module_list()
return modules
