local modules = require("misc").module_list()

vim.diagnostic.config({
  virtual_text = {
    prefix = "",
  },
})

return modules
