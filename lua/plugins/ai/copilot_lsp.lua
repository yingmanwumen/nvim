return {
  "copilotlsp-nvim/copilot-lsp",
  init = function()
    vim.g.copilot_nes_debounce = 250
    vim.lsp.enable("copilot_ls")
  end,
  enabled = false,
  opts = {
    nes = {
      move_count_threshold = 2,
      distance_threshold = 40,
      clear_on_large_distance = true,
      count_horizontal_moves = true,
      reset_on_approaching = true,
    },
  },
}
