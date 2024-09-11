return {
  "Saecki/crates.nvim",
  tag = "stable",
  event = { "BufRead Cargo.toml" },
  config = function()
    require("crates").setup({
      lsp = {
        enabled = true,
        actions = true,
        hover = true,
        completion = true,
      },
    })
  end,
}
