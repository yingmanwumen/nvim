-- local function macro_recording()
--   ---@diagnostic disable-next-line: different-requires
--   local mode = require("noice").api.statusline.mode.get()
--   if mode then
--     return string.match(mode, "^recording @.*") or ""
--   end
--   return ""
-- end
--
-- local function get_navic()
--   ---@diagnostic disable-next-line: different-requires
--   local navic = require("nvim-navic")
--   if navic.is_available() then
--     return navic.get_location()
--   end
--   return ""
-- end

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
        lualine_x = {
          "encoding",
          "filetype",
        },
      },
    })
  end,
}
