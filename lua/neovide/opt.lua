vim.o.mouse = "nv"
vim.g.neovide_input_ime = true
vim.g.neovide_refresh_rate = 120
vim.g.neovide_no_idle = true
-- vim.g.neovide_cursor_vfx_mode = "railgun"
-- vim.g.neovide_cursor_vfx_mode = "sonicboom"
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_text_gamma = 2.2
vim.g.neovide_text_contrast = 0.5
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_corner_radius = 0.8
vim.o.linespace = 5
vim.g.neovide_opacity = 0.95
vim.g.neovide_theme = "bg_color"

if vim.uv.os_uname().sysname == "Darwin" then
  vim.g.neovide_window_blurred = true
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  -- vim.o.guifont = "Liga ComicShannsMono Nerd Font"
  vim.o.guifont = "FiraCode Nerd Font"
  -- vim.o.guifont = "JetBrainsMono Nerd Font"
else
  -- vim.o.guifont = "Liga ComicShannsMono Nerd Font,LXGW WenKai,Apple Color Emoji:h11.5"
  vim.o.guifont = "FiraCode Nerd Font,LXGW WenKai,Apple Color Emoji:h11"
  -- vim.o.guifont = "JetBrains Nerd Font,LXGW WenKai,Apple Color Emoji"
end

vim.api.nvim_create_autocmd({ "WinClosed", "WinResized", "BufWinEnter" }, {
  callback = function()
    if vim.g.neovide then
      vim.cmd("redraw")
    end
  end,
})
