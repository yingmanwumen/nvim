vim.o.mouse = "nv"
vim.g.neovide_input_ime = true
vim.g.neovide_refresh_rate = 120
vim.g.neovide_no_idle = true
-- vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_mode = "sonicboom"
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_text_gamma = 2.2
vim.g.neovide_text_contrast = 0.5

if vim.uv.os_uname().sysname == "Darwin" then
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  -- vim.o.guifont = "Liga ComicShannsMono Nerd Font"
  -- vim.o.guifont = "Maple Mono NF CN"
  vim.o.guifont = "FiraCode Nerd Font"
  -- vim.o.guifont = "JetBrainsMono Nerd Font"
  vim.o.linespace = 5
else
  -- vim.o.guifont = "Liga ComicShannsMono Nerd Font,LXGW WenKai,Apple Color Emoji:h11.5"
  -- vim.o.linespace = 0
  vim.o.guifont = "FiraCode Nerd Font,LXGW WenKai,Apple Color Emoji:h11.5"
  vim.o.linespace = 5
  -- vim.g.neovide_scale_factor = 1.1
  -- vim.o.guifont = "JetBrainsMono Nerd Font,LXGW WenKai,Apple Color Emoji"
end
