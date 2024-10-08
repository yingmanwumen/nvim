-- global settings which are plugins and languages independent

local this = {}

function this.setup()
  require("opt.settings")
  require("opt.keymap")
  require("opt.autocmd")
  if vim.g.neovide then
    require("neovide")
  end
end

return this
