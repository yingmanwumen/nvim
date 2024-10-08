local icons = require("plugins.editor.outline.icons")
local opts = {
  keymaps = {
    show_help = "?",
    close = { "<Esc>", "q" },
    goto_location = "<CR>",
    peek_location = "<Tab>",
    goto_and_close = "<C-CR>",
    restore_location = "<S-CR>",
    hover_symbol = "K",
    toggle_preview = "p",
    rename_symbol = "<leader>rn",
    code_actions = "<C-.>",
    fold = "h",
    unfold = "l",
    fold_toggle = "o",
    fold_toggle_all = "za",
    fold_all = "zm",
    unfold_all = "zo",
  },
  symbols = {
    icons = {
      File = { icon = icons.File, hl = "@text.uri" },
      Module = { icon = icons.Module, hl = "@namespace" },
      Namespace = { icon = icons.Namespace, hl = "@namespace" },
      Package = { icon = icons.Package, hl = "@namespace" },
      Class = { icon = icons.Class, hl = "@type" },
      Method = { icon = icons.Method, hl = "@method" },
      Property = { icon = icons.Property, hl = "@method" },
      Field = { icon = icons.Field, hl = "@field" },
      Constructor = { icon = icons.Constructor, hl = "@constructor" },
      Enum = { icon = icons.Enum, hl = "@type" },
      Interface = { icon = icons.Interface, hl = "@type" },
      Function = { icon = icons.Function, hl = "@function" },
      Variable = { icon = icons.Variable, hl = "@constant" },
      Constant = { icon = icons.Constant, hl = "@constant" },
      String = { icon = icons.String, hl = "@string" },
      Number = { icon = icons.Number, hl = "@number" },
      Boolean = { icon = icons.Boolean, hl = "@boolean" },
      Array = { icon = icons.Array, hl = "@constant" },
      Object = { icon = icons.Object, hl = "@type" },
      Key = { icon = icons.Key, hl = "@type" },
      Null = { icon = icons.Null, hl = "@type" },
      EnumMember = { icon = icons.EnumMember, hl = "@field" },
      Struct = { icon = icons.Struct, hl = "@type" },
      Event = { icon = icons.Event, hl = "@type" },
      Operator = { icon = icons.Operator, hl = "@Operator" },
      TypeParameter = { icon = icons.TypeParameter, hl = "@parameter" },
      Component = { icon = icons.Component, hl = "@function" },
    },
  },
}

return {
  "hedyhli/outline.nvim",
  cmd = "Outline",
  keys = {
    { "<M-v>", "<Cmd>Outline<CR>" },
  },
  config = function()
    require("outline").setup(opts)
  end,
}
