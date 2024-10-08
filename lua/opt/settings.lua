vim.cmd([[
  syntax sync maxlines=2000
]])

vim.o.number = true
vim.o.scrolloff = 3
vim.o.shell = "/bin/zsh"
vim.o.autoread = true
vim.o.autoindent = true
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 0
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99
vim.o.foldenable = false
vim.o.laststatus = 3
vim.o.list = true
vim.o.listchars = "tab:»-,trail:·,nbsp:·,extends:→,precedes:←"
vim.o.shiftwidth = 2
vim.o.showbreak = "󱞩 "
vim.o.signcolumn = "yes"
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.o.updatetime = 500
vim.o.timeoutlen = 500

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
