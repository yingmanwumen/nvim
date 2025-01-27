if vim.uv.os_uname().sysname == "Darwin" then
  return {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local neocodeium = require("neocodeium")
      neocodeium.setup({
        show_label = false,
        silent = true,
      })
      vim.keymap.set("i", "<tab>", function()
        if neocodeium.visible() then
          neocodeium.accept()
        else
          return "<tab>"
        end
      end, { silent = true, expr = true })
      vim.keymap.set("i", "<C-CR>", function()
        if neocodeium.visible() then
          neocodeium.accept()
        else
          return "<tab>"
        end
      end, { silent = true, expr = true })
      vim.keymap.set("i", "<M-c>", neocodeium.clear)
      vim.keymap.set("i", "<M-]>", function()
        neocodeium.cycle(1)
      end)
      vim.keymap.set("i", "<M-[>", function()
        neocodeium.cycle(-1)
      end)
    end,
  }
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
