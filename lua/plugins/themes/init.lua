local this = {}
local themes = require("plugins.themes.themes")

this.default = "tokyonight"
this.themes = themes
this.dark = false

function this.get(theme)
  theme = theme or this.default
  return this.to_spec(this.themes[theme])
end

function this.get_themes()
  return this.themes
end

function this.to_spec(theme)
  return {
    theme.package,
    opt = theme.opts or nil,
  }
end

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
  local res = {}
  for _, v in pairs(this.get_themes()) do
    res[#res + 1] = this.to_spec(v)
  end
  return res
end

return this
