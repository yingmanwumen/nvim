local function setup()
  local ft = require("guard.filetype")

  ft("bash,csh,ksh,sh,zsh"):fmt("shfmt")

  ft("c,cpp"):fmt("clang-format"):extra("--style={BasedOnStyle: google, IndentWidth: 2}")

  ft("lua"):fmt("stylua")

  ft("python"):fmt("black")

  ft("json,jsonc,angular,css,flow,graphql,html,jsx,javascript,less,markdown,scss,typescript,vue,yaml"):fmt("prettierd")

  ft("sql"):fmt({
    cmd = "sqlfmt",
    stdin = false,
    fname = true,
  })

  ft("ocaml"):fmt({
    cmd = "ocamlformat",
    stdin = false,
    fname = true,
  })

  -- ft("haskell"):fmt({
  --   cmd = "fourmolu",
  --   args = { "-i" },
  --   stdin = false,
  --   fname = true,
  -- })

  require("guard").setup({
    fmt_on_save = true,
    lsp_as_default_formatter = false,
  })
end

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
  config = setup,
}
