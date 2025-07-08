return {
  "mason-org/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
  config = function()
    require("mason").setup()
  end,
}
