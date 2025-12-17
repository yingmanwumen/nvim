return {
  "Exafunction/windsurf.vim",
  event = {
    "InsertEnter",
    "BufReadPost",
  },
  keys = {
    {
      "<M-c>",
      function()
        return vim.fn["codeium#Clear"]()
      end,
      mode = "i",
      desc = "Clear Codeium completion",
    },
    -- This is commented out to avoid conflict with other completion plugins
    -- {
    --   "<tab>",
    --   function()
    --     return vim.fn["codeium#Accept"]()
    --   end,
    --   mode = "i",
    --   nowait = true,
    --   expr = true,
    --   silent = true,
    --   script = true,
    --   desc = "Accept Codeium completion",
    -- },
    {
      "<M-]>",
      function()
        return vim.fn["codeium#CycleCompletions"](1)
      end,
      mode = "i",
      nowait = true,
      expr = true,
      silent = true,
      script = true,
      desc = "Cycle completions forward",
    },
    {
      "<M-[>",
      function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end,
      mode = "i",
      nowait = true,
      expr = true,
      silent = true,
      script = true,
      desc = "Cycle completions backward",
    },
    {
      "<M-Bslash>",
      function()
        -- Trigger Codeium completion manually
        return vim.fn["codeium#Complete"]()
      end,
      mode = "i",
      nowait = true,
      expr = true,
      silent = true,
      script = true,
      desc = "Trigger Codeium completion manually",
    },
  },
}
