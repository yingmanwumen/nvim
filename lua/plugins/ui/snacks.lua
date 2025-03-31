return {
  "stevearc/snacks.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    notifier = { enabled = false },
    picker = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },

    input = { enabled = true },
    quickfile = { enabled = true },
    styles = {
      input = {
        relative = "cursor",
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    vim.g.snacks_animate = false
  end,
}
