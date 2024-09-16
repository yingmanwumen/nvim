vim.o.mouse = "nv"
vim.g.neovide_input_ime = true
vim.g.neovide_refresh_rate = 120
vim.g.neovide_no_idle = true
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_hide_mouse_when_typing = true
vim.o.guifont = "Liga ComicShannsMono Nerd Font,PingFang SC,Apple Color Emoji"

if vim.uv.os_uname().sysname == "Darwin" then
  vim.g.neovide_input_macos_option_key_is_meta = "both"
end
