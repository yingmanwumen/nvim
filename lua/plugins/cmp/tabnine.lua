return {
  "tzachar/cmp-tabnine",
  event = "InsertEnter",
  enabled = false,
  build = "./install.sh",
  dependencies = "hrsh7th/nvim-cmp",
  config = function()
    local tabnine = require("cmp_tabnine.config")

    tabnine:setup({
      max_lines = 1000,
      max_num_results = 3,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = "󰇘",
      show_prediction_strength = true,
      min_percent = 0,
    })
  end,
}
