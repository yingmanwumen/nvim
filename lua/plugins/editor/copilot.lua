return {
  "zbirenbaum/copilot.lua",
  -- "yingmanwumen/copilot.lua",
  event = "InsertEnter",
  cmd = "Copilot",
  config = function()
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
  end,
  -- enabled = false,
}
