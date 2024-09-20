-- vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
-- vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
-- vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })

-- This plugin has bad performance with large files
return {
  "RRethy/vim-illuminate",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  keys = {
    { "<M-j>", "<Cmd>lua require('illuminate').goto_next_reference()<CR>" },
    { "<M-k>", "<Cmd>lua require('illuminate').goto_prev_reference()<CR>" },
  },
  config = function()
    require("illuminate").configure({
      large_file_cutoff = 500,
    })
  end,
}
