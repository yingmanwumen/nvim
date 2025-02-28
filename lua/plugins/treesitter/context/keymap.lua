local bind = vim.keymap.set

bind({ "n", "x" }, "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, {
  silent = true,
  desc = "go to context",
})
