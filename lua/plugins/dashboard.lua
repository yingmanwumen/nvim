local this = {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require('dashboard').setup({
      theme         = "hyper",
      disable_move  = true,
      shortcut_type = "number",
      config        = {
        week_header = { enable = true },
        project     = { enable = true },
        shortcut    = {
          {
            icon    = "🔧",
            icon_hl = "@variable",
            desc    = "Lazy",
            group   = "Label",
            action  = "Lazy",
            key     = "L",
          },
          {
            icon    = "📚",
            icon_hl = "@variable",
            desc    = "Mason",
            group   = "Label",
            action  = "Mason",
            key     = "M",
          },
        },
        mru         = { limit = 20 },
        hide        = {
          statusline = true,
          tabline    = true,
        },
        footer      = function()
          return {}
        end
      }
    })
  end
}

return this
