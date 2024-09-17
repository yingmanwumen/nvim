local function fcitx5()
  vim.api.nvim_create_autocmd({ "InsertLeave", "BufCreate", "BufEnter", "BufLeave" }, {
    pattern = "*",
    callback = function()
      vim.fn.system("fcitx5-remote -c")
    end,
  })
end

local function autoread()
  local utils = require("utils")
  utils.set_timer(1000, function()
    vim.cmd([[silent! checktime]])
  end)
end

autoread()
if vim.uv.os_uname().sysname == "Linux" then
  fcitx5()
end
