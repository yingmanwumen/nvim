-- local function get_volar_location()
--   local home = os.getenv("HOME")
--   if vim.uv.os_uname().sysname == "Darwin" then
--     return home .. "/.nvm/versions/node/v20.15.0/lib/node_modules/@volar"
--   else
--     return ""
--   end
-- end

return {
  lsp = "ts_ls",
  opts = {
    init_options = {
      -- plugins = { -- I think this was my breakthrough that made it work
      --   {
      --     name = "@vue/typescript-plugin",
      --     location = get_volar_location(),
      --     languages = { "vue" },
      --   },
      -- },
    },
    -- filetypes = { "typescript", "javascript", "vue" },
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = { enabled = true },
          includeInlayFunctionLikeReturnTypeHints = { enabled = true },
          includeInlayParameterNameHints = { enabled = "all" },
          includeInlayParameterTypeHints = { enabled = true },
          includeInlayPropertyDeclarationTypeHints = { enabled = true },
          includeInlayVariableTypeHints = { enabled = true },
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = { enabled = true },
          includeInlayFunctionLikeReturnTypeHints = { enabled = true },
          includeInlayParameterNameHints = { enabled = "all" },
          includeInlayParameterTypeHints = { enabled = true },
          includeInlayPropertyDeclarationTypeHints = { enabled = true },
          includeInlayVariableTypeHints = { enabled = true },
        },
      },
    },
  },
}
