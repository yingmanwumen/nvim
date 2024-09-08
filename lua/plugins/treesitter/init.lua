local this = {}

this.plugins = {
  require('plugins.treesitter.rainbow-delimiters'),
  require('plugins.treesitter.treesitter'),
  require('plugins.treesitter.context'),
  require('plugins.treesitter.twilight'),
  require('plugins.treesitter.autotag'),
  require('plugins.treesitter.commentstring'),
}

require('plugins.treesitter.keymap')

function this.list()
  return this.plugins
end

return this
