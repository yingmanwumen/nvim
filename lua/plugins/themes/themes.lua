return {
  {
    "folke/tokyonight.nvim",
    opts = { style = "moon" },
  },

  { "projekt0n/github-nvim-theme" },

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
}
