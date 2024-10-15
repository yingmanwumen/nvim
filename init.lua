-- preload settings before loading the package manager and other plugins
require("opt").setup()

-- load the package manager lazy.nvim
require("lazy_nvim").setup()

vim.opt.background = "light"
vim.cmd("colorscheme solarized")
