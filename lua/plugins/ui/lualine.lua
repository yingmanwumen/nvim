local function macro_recording()
  local mode = require("noice").api.statusline.mode.get()
  if mode then
    return string.match(mode, "^recording @.*") or ""
  end
  return ""
end

return {
  "nvim-lualine/lualine.nvim",
  event = { "VeryLazy" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        globalstatus = true,
        disabled_filetypes = {
          statusline = {
            "lazy",
            "dashboard",
          },
        },
      },
      sections = {
        lualine_c = {
          "filename",
          macro_recording,
        },
        lualine_x = {
          "encoding",
          "filetype",
        },
      },
    })
  end,
}
