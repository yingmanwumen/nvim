local function open_menu()
  local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
  require("menu").open(options, { border = true })
end

return {
  "NvChad/menu",
  dependencies = "NvChad/volt",
  keys = {
    {
      "<C-s-m>",
      open_menu,
    },
  },
}
