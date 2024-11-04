vim.o.mouse = "nv"
vim.g.neovide_input_ime = true
vim.g.neovide_refresh_rate = 120
vim.g.neovide_no_idle = true
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_hide_mouse_when_typing = true

if vim.uv.os_uname().sysname == "Darwin" then
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.o.guifont = "Liga ComicShannsMono Nerd Font"
else
  vim.o.guifont = "Liga ComicShannsMono Nerd Font,LXGW WenKai,Apple Color Emoji"
  -- vim.o.guifont = "JetBrainsMono Nerd Font,LXGW WenKai,Apple Color Emoji"
end
