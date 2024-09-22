return {
  "OXY2DEV/markview.nvim",
  ft = "markdown", -- If you decide to lazy-load anyway
  config = function()
    require("markview").setup({
      modes = { "n", "i", "no", "c" },
      hybrid_modes = { "i" },
      checkboxes = {
        checked = { text = " " },
      },
      code_blocks = {
        style = "minimal",
      },
      list_items = {
        shiftwidth = 2,
        indent_width = 2,
        marker_minus = {
          add_padding = false,
        },
        marker_plus = {
          add_padding = false,
        },
        marker_star = {
          add_padding = false,
        },
        marker_dot = {
          add_padding = false,
        },
      },
      -- This is nice to have
      callbacks = {
        on_enable = function(_, win)
          vim.wo[win].conceallevel = 3
          vim.wo[win].concealcursor = ""
        end,
      },
    })
  end,
}
