local this = {}
local themes = require("plugins.themes.themes")

this.default = "tokyonight"
this.themes = themes
this.dark = false

---@type fun(theme: string)
function this.set(theme)
  this.default = theme
end

function this.activate(theme)
  theme = theme or this.default
  if this.dark then
    vim.opt.background = "dark"
  else
    vim.opt.background = "light"
  end
  vim.cmd("colorscheme " .. theme)
end

function this.list()
  return this.themes
end

return this
