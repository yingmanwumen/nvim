local function bind(lhs, rhs, desc, mode)
  if mode == nil then
    mode = "n"
  end
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

bind("[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "Go to previous diagnostic")
bind("]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", "Go to next diagnostic")
bind("<C-.>", "<Cmd>Lspsaga code_action<CR>", "Code action")
