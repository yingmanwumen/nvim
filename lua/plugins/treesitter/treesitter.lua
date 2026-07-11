return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua", "cmake", "cpp", "rust", "python", "golang" },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
