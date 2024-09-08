local this = {}

local function load_plugin(plugin)
  this[#this + 1] = plugin
end

local function load_plugins(plugins)
  for _, plugin in ipairs(plugins) do
    load_plugin(plugin)
  end
end

-- load themes
local themes = require('plugins.themes')
load_plugins(themes.list())

-- load ui
local dashboard = require('plugins.dashboard')
load_plugin(dashboard)

-- load treesitter
local treesitter = require('plugins.treesitter')
load_plugins(treesitter.list())

load_plugin(require('plugins.comment'))

return this
