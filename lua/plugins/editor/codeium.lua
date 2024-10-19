if vim.uv.os_uname().sysname == "Darwin" then
  return {}
else
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
end
