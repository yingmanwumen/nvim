local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  local function opts(desc)
    return {
      desc    = "nvim-tree: " .. desc,
      buffer  = bufnr,
      noremap = true,
      silent  = true,
      nowait  = true
    }
  end

  local function set(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, opts(desc))
  end

  local function git_stage()
    local node = api.tree.get_node_under_cursor()
    local gs = node.git_status.file

    -- If the current node is a directory get children status
    if gs == nil then
      gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
          or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
    end

    if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
      -- If the file is untracked, unstaged or partially staged, we stage it
      os.execute("git add " .. node.absolute_path)
    elseif gs == "M " or gs == "A " then
      -- If the file is staged, we unstage
      os.execute("git restore --staged " .. node.absolute_path)
    end

    api.tree.reload()
  end

  --------------------------------------------------------------------------------
  --                              Custom Mappings                               --
  --------------------------------------------------------------------------------
  set('?', api.tree.toggle_help, 'Toggle Help')

  -- Git
  set('[g', api.node.navigate.git.prev, 'Prev Git')
  set(']g', api.node.navigate.git.next, 'Next Git')
  set('I', api.tree.toggle_gitignore_filter, 'Toggle Git Ignore')
  set('gs', git_stage, 'Git Stage')

  -- Open
  set('s', api.node.open.horizontal, 'Horizontal Split')
  set('<C-v>', api.node.open.vertical, 'Vertical Split')
  set('<CR>', api.node.open.edit, 'Open')
  set('o', api.node.open.edit, 'Open')
  set('<2-LeftMouse>', api.node.open.edit, 'Open')
  set('<Tab>', api.node.open.preview, 'Preview')

  -- Filesystem
  set('a', api.fs.create, 'Create File Or Directory')
  set('c', api.fs.copy.node, 'Copy')
  set('x', api.fs.cut, 'Cut')
  set('d', api.fs.remove, 'Delete')
  set('r', api.fs.rename, 'Rename')
  set('Y', api.fs.copy.absolute_path, 'Copy Absolute Path')
  set('y', api.fs.copy.relative_path, 'Copy Relative Path')
  set('p', api.fs.paste, 'Paste')

  -- Lsp
  set(']d', api.node.navigate.diagnostics.next, 'Next Diagnostic')
  set('[d', api.node.navigate.diagnostics.prev, 'Prev Diagnostic')

  -- Filter
  set('B', api.tree.toggle_no_buffer_filter, 'Toggle No Buffer')
  set('f', api.live_filter.start, 'Live Filter')
  set('F', api.live_filter.clear, 'Live Filter Clear')

  -- Root
  set('-', api.tree.change_root_to_parent, 'Up')
  set('<BS>', api.tree.change_root_to_parent, 'Up')
  set('=', api.tree.change_root_to_node, 'CD')

  -- Misc
  set('K', api.node.show_info_popup, 'Info Popup')
  set('.', api.node.run.cmd, 'Run Command')
  set('H', api.tree.toggle_hidden_filter, 'Toggle Hidden')
  set('q', api.tree.close, 'Close')
  set('R', api.tree.reload, 'Refresh')
end

return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    { "<M-e>", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree", mode = "n" }
  },
  config = function()
    require("nvim-tree").setup({
      on_attach           = on_attach,
      sync_root_with_cwd  = true,
      respect_buf_cwd     = true,
      update_cwd          = true,
      update_focused_file = {
        enable      = true,
        update_root = true,
      },
      filters             = {
        dotfiles = true,
      }
    })
  end
}
