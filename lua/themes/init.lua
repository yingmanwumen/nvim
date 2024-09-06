local this = {}
local themes = {}

themes.tokyonight = {
  package = "folke/tokyonight.nvim",
  opts = { style = "moon" },
}

this.default = "tokyonight"
this.themes = themes

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
  vim.cmd("colorscheme " .. theme)
end

return this
