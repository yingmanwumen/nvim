return {
  {
    "folke/tokyonight.nvim",
    opts = { style = "moon" },
  },

  {
    "projekt0n/github-nvim-theme",
    config = function()
      require("github-theme").setup({
        options = {
          styles = { -- Style to be applied to different syntax groups
            comments = "bold", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "italic",
            constants = "NONE",
            functions = "bold",
            keywords = "italic",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "bold",
            variables = "NONE",
          },
        },
      })
    end,
  },

  { "pappasam/papercolor-theme-slim" },

  {
    "maxmx03/solarized.nvim",
    config = function()
      require("solarized").setup({
        variant = "summer",
        error_lens = {
          text = true,
          symbol = true,
        },
      })
    end,
  },

  { "ofirgall/ofirkai.nvim" },

  { "diegoulloao/neofusion.nvim" },

  { "sainnhe/everforest" },

  { "shaunsingh/nord.nvim" },

  { "ellisonleao/gruvbox.nvim" },

  { "sainnhe/gruvbox-material" },

  { "navarasu/onedark.nvim" },

  { "Mofiqul/vscode.nvim" },

  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        styles = { -- Style to be applied to different syntax groups
          comments = "bold", -- Value is any valid attr-list value `:help attr-list`
          conditionals = "italic",
          constants = "NONE",
          functions = "bold",
          keywords = "italic",
          numbers = "NONE",
          operators = "NONE",
          strings = "NONE",
          types = "bold",
          variables = "NONE",
        },
      },
    },
  },

  {
    "Mofiqul/dracula.nvim",
    opts = {
      italic_comment = true,
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      styles = {
        comments = { "bold" },
        conditionals = { "italic" },
        loops = {},
        functions = { "bold" },
        keywords = { "italic" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = { "italic" },
        types = { "bold" },
        operators = {},
      },
    },
  },
}
