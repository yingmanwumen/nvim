return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    config = function()
      require("ibl").setup({
        scope = {
          enabled = false,
        },
        indent = {
          char = "│",
        },
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    config = function()
      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "dashboard",
          "Trouble",
          "lazy",
          "mason",
          "Outline",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
