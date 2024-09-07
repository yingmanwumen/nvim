vim.g.mapleader = " "
vim.g.maplocalleader = " "

local bind = vim.keymap.set

bind(
  { "n", "v" },
  "Q",
  ":q<CR>",
  {
    silent = true,
    desc = "quit"
  }
)

bind(
  "n",
  "<M-w>",
  ":bd %<CR>",
  {
    silent = true,
    desc = "close buffer"
  }
)

bind(
  "n",
  "<M-s>",
  ":w<CR>",
  {
    silent = true,
    desc = "save file"
  }
)

bind(
  "v",
  "<",
  "<gv",
  {
    silent = true,
    desc = "unindent"
  }
)

bind(
  "v",
  ">",
  ">gv",
  {
    silent = true,
    desc = "indent"
  }
)

bind(
  "t",
  "<M-->",
  "<C-\\><C-n>:q<CR>",
  {
    silent = true,
    desc = "close terminal"
  }
)

bind(
  "t",
  "<M-q>",
  "<C-\\><C-n>",
  {
    silent = true,
    desc = "normal mode"
  }
)

bind(
  "n",
  "<C-Right>",
  "<C-w>>",
  {
    silent = true,
    desc = "expand window"
  }
)

bind(
  "n",
  "<C-Left>",
  "<C-w><",
  {
    silent = true,
    desc = "shrink window"
  }
)

bind(
  "n",
  "<C-Up>",
  "<C-w>+",
  {
    silent = true,
    desc = "expand window vertically"
  }
)

bind(
  "n",
  "<C-Down>",
  "<C-w>-",
  {
    silent = true,
    desc = "shrink window vertically"
  }
)
