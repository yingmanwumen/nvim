vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "markdown",
  },
  callback = function()
    vim.o.conceallevel = 2
  end,
})

local modules = require("utils").module_list()
return modules
