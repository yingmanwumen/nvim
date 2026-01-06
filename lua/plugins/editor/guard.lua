local function setup()
  local ft = require("guard.filetype")
  local lint = require("guard.lint")

  ft("bash,csh,ksh,sh,zsh"):fmt("shfmt")

  ft("cpp"):fmt("clang-format"):extra("--style={BasedOnStyle: google, IndentWidth: 2}")
  ft("c"):fmt("clang-format"):extra("--style={BasedOnStyle: google, IndentWidth: 4}")

  ft("lua"):fmt("stylua")

  ft("go"):fmt("gofmt")

  -- ft("python"):fmt("black"):lint("flake8")
  ft("python"):fmt("ruff")

  -- ft("python"):fmt("black"):lint({
  --   cmd = "pylint",
  --   args = { "--output-format", "json" },
  --   stdin = false,
  --   fname = true,
  --   parse = lint.from_json({
  --     attributes = {
  --       severity = "type",
  --       code = "symbol",
  --     },
  --     severities = {
  --       convention = lint.severities.info,
  --       refactor = lint.severities.info,
  --       informational = lint.severities.info,
  --       fatal = lint.severities.error,
  --     },
  --     source = "pylint",
  --   }),
  -- })

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
    args = { "-i", "--enable-outside-detected-project", "--profile=janestreet" },
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

  ft("clojure"):fmt({
    cmd = "cljfmt",
    args = { "fix" },
    stdin = false,
    fname = true,
  })

  ft("toml"):fmt({
    cmd = "taplo",
    args = { "fmt" },
    stdin = false,
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
    -- Most binaries of mine are managed by Mason
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  config = setup,
}
