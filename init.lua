-- Preload settings before loading the package manager and other plugins
require("opt").setup()

-- load the package manager lazy.nvim
require("lazy_nvim").setup()

if vim.uv.os_uname().sysname == "Darwin" then
  vim.opt.background = "light"
  vim.cmd("colorscheme github_light")
else
  vim.opt.background = "dark"
  -- vim.cmd("colorscheme tokyonight")
  -- vim.cmd("colorscheme onedark")
  vim.cmd("colorscheme nightfox")
  -- vim.opt.background = "light"
  -- vim.cmd("colorscheme github_light")
end
