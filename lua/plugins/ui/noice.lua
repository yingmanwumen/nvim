return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("noice").setup({
      cmdline = {},
      messages = {},
      popupmenu = {},
      redirect = {},
      commands = {},
      notify = {},
      lsp = {
        hover = {
          -- enabled = false,
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      health = {},
      throttle = 1000 / 30,
      views = {},
      status = {},
      format = {},
      markdown = {},
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          filter = {
            find = "-32603: Invalid offset",
          },
          opts = { skip = true },
        },
        {
          filter = {
            find = "Wasn't able to open",
          },
          opts = { skip = true },
        },
      },
    })
  end,
}
