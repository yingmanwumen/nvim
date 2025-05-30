local misc = require("misc")

local setup_cmp = function()
  require("cmp").setup.filetype("markdown", {
    sources = {
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "cmp_tabnine" },
      { name = "path" },
      { name = "nerdfont" },
    },
  })
end

local function setup()
  vim.cmd([[setlocal shiftwidth=2]])
  misc.autosave()
  setup_cmp()
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
