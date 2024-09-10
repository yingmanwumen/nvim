vim.g.mapleader = " "
vim.g.maplocalleader = " "

local bind = vim.keymap.set

bind(
  "n",
  "<M-w>",
  "<C-w>",
  {
    silent = true,
    desc = "window"
  }
  )

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
  "<M-q>",
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

bind(
  { "n", "v" },
  "<C-S-V>",
  '"+P',
  {
    silent = true,
    desc = "paste from clipboard"
  }
)

bind(
  { "c", "i" },
  "<C-S-V>",
  '<C-R>+',
  {
    silent = true,
    desc = "paste from clipboard"
  }
)
