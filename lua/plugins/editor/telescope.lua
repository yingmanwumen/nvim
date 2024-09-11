local function setup()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  telescope.setup({
    defaults = {
      dynamic_preview_title = true,
      prompt_prefix = "❯ ",
      selection_caret = "➤ ",
      sorting_strategy = "ascending",
      mappings = {
        i = {
          ["<esc>"] = actions.close,
        },
      },
    },
    pickers = {
      builtin = { theme = "ivy", previewer = false },
    },
  })
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    -- Notice! map ctrl+shift+p to \x1b[80;5u in terminal
    { "<C-S-P>", "<Cmd>Telescope<CR>" },
    { "<M-f>b", "<Cmd>Telescope buffers<CR>" },
    { "<M-f>f", "<Cmd>Telescope find_files<CR>" },
    { "<M-f>l", "<Cmd>Telescope current_buffer_fuzzy_find<CR>" },
    { "<M-f>r", "<Cmd>Telescope live_grep<CR>" },
  },
  config = setup,
}
