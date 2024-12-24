return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    keywords = {
      SAFETY = {
        icon = "🚨",
        color = "error",
      },
    },
  },
}
