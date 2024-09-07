-- global settings which are plugins and languages independent

local this = {}

function this.setup()
  require("opt.settings")
  require("opt.keymap")
  require("neovide")
end

return this
