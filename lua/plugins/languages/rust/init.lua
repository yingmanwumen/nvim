vim.cmd([[
  hi! @lsp.mod.mutable.rust cterm=underline gui=underline
]])

local modules = require("utils").module_list()
return modules
