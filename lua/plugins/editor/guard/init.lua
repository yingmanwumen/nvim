return {
  "nvimdev/guard.nvim",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  -- Builtin configuration, optional
  dependencies = {
    "nvimdev/guard-collection",
    -- Most binariese of mine are managed by Mason
    "williamboman/mason.nvim",
  },
  config = function()
    local ft = require("guard.filetype")
    ft("bash,csh,ksh,sh,zsh"):fmt("shfmt")

    ft("c,cpp"):fmt("clang-format"):extra("--style={BasedOnStyle: google, IndentWidth: 2}")

    ft("lua"):fmt("stylua")
    require("guard").setup({
      fmt_on_save = true,
      lsp_as_default_formatter = false,
    })
  end,
}
