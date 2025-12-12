local themes = require("plugins.themes.themes")

vim.api.nvim_set_hl(0, "@lsp.mod.mutable", { underline = true })
vim.api.nvim_set_hl(0, "keyword", { italic = true })
vim.api.nvim_set_hl(0, "@lsp.type.property", { italic = true })
vim.api.nvim_set_hl(0, "@lsp.type.parameter", { italic = true })
vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { bold = true })
vim.api.nvim_set_hl(0, "@lsp.type.comment", { bold = true })
vim.api.nvim_set_hl(0, "@lsp.type.variable", { italic = false })

return themes
