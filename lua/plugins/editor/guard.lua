local function setup()
  local ft = require("guard.filetype")

  ft("bash,csh,ksh,sh,zsh"):fmt("shfmt")

  ft("cpp"):fmt("clang-format"):extra("--style={BasedOnStyle: google, IndentWidth: 2}")
  ft("c"):fmt("clang-format"):extra("--style={BasedOnStyle: google, IndentWidth: 4}")

  ft("lua"):fmt("stylua")

  ft("python"):fmt("black")

  ft("json,jsonc,angular,css,flow,graphql,html,jsx,javascript,less,markdown,scss,typescript,vue,yaml,typescriptreact"):fmt(
    "prettierd"
  )

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

  ft("proto"):fmt({
    cmd = "buf",
    args = { "format", "-w" },
    stdin = false,
    fname = true,
  })

  ft("haskell"):fmt({
    cmd = "fourmolu",
    args = { "--stdin-input-file" },
    stdin = true,
    fname = true,
  })

  vim.g.guard_config = {
    fmt_on_save = true,
    lsp_as_default_formatter = false,
    save_on_format = false,
  }
end

return {
  "nvimdev/guard.nvim",
  -- "yingmanwumen/guard.nvim",
  ft = "*",
  -- Builtin configuration, optional
  dependencies = {
    "nvimdev/guard-collection",
    -- Most binariese of mine are managed by Mason
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = setup,
}
