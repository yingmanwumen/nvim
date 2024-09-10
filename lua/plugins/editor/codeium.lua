return {
  "Exafunction/codeium.vim",
  event = {
    "InsertEnter",
    "BufReadPost",
  },
  keys = {
    { "<M-c>", "<Cmd>call codeium#Clear()<CR>", mode = "i" },
    {
      "<tab>",
      "codeium#Accept()",
      mode = "i",
      nowait = true,
      expr = true,
      silent = true,
      script = true,
    },
  },
}
