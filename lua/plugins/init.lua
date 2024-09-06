local this = {}

local index = 1

local function load_plugin(plugin)
  this[index] = plugin
  index = index + 1
end

local themes = require('themes')
for _, v in pairs(themes.get_themes()) do
  load_plugin(themes.to_spec(v))
end

return this
