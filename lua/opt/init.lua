-- global settings which are plugins and languages independent

local this = {}

function this.setup()
  require("opt.settings")
  require("opt.keymap")
  if vim.g.neovide then
    require("neovide")
  end
end

return this
