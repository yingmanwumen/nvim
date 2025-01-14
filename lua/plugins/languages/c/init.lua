local function setup()
  vim.cmd([[setlocal shiftwidth=4]])
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c" },
  callback = setup,
})

-- file with postfix .h is a C file
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter", "BufWinEnter" }, {
  pattern = "*.h",
  callback = function()
    vim.cmd([[setlocal filetype=c]])
  end,
})

local modules = require("misc").module_list()
return modules
