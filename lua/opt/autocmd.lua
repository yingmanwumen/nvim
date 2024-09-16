local function fcitx5()
  vim.api.nvim_create_autocmd({ "InsertLeave", "BufCreate", "BufEnter", "BufLeave" }, {
    pattern = "*",
    callback = function()
      vim.fn.system("fcitx5-remote -c")
    end,
  })
end

if vim.uv.os_uname().sysname == "Linux" then
  fcitx5()
end
