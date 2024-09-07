local bind = vim.keymap.set

local function neovide_scale(amount)
  local temp = vim.g.neovide_scale_factor + amount
  if temp < 0.5 then
    return
  end
  vim.g.neovide_scale_factor = temp
end

bind(
  "n",
  "<C-=>",
  function()
    neovide_scale(0.1)
  end,
  {
    desc = "neovide scale up",
    silent = true,
  }
)

bind(
  "n",
  "<C-->",
  function()
    neovide_scale(-0.1)
  end,
  {
    desc = "neovide scale down",
    silent = true,
  }
)

bind(
  "n",
  "<F11>",
  function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end,
  {
    desc = "neovide fullscreen",
    silent = true,
  }
)
