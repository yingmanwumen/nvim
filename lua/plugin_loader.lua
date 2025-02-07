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
local themes = require("plugins.themes")
load_plugins(themes.list())

load_plugins(require("plugins.ai"))
load_plugins(require("plugins.cmp"))
load_plugins(require("plugins.dap"))
load_plugins(require("plugins.editor"))
load_plugins(require("plugins.git"))
load_plugins(require("plugins.languages"))
load_plugins(require("plugins.lsp"))
load_plugins(require("plugins.project"))
load_plugins(require("plugins.snip"))
load_plugins(require("plugins.treesitter"))
load_plugins(require("plugins.ui"))

return this
