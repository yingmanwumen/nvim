return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("rainbow-delimiters.setup").setup({
      condition = function(buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return false
        end
        return true
      end,
    })
  end,
}
