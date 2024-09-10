return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    { "<C-/>", "<Plug>(comment_toggle_linewise_current)", mode = { "n" } },
    { "<C-/>", "<Plug>(comment_toggle_linewise_visual)", mode = { "x" } },
  },
  config = function()
    require("Comment").setup({
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
  end,
}
