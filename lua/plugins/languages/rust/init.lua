vim.cmd([[
  hi! @lsp.mod.mutable.rust cterm=underline gui=underline
]])

local modules = require("misc").module_list()
return modules
