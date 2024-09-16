local utils = require("utils")

local function setup()
  utils.autosave()
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit" },
  callback = setup,
})

return {}
