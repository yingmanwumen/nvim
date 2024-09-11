vim.g.doge_doc_standard_cpp = "doxygen_qt"
vim.g.doge_doc_standard_c = "kernel_doc"

return {
  "kkoomen/vim-doge",
  build = ":call doge#install()",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
}
