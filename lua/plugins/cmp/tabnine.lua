return {
  "tzachar/cmp-tabnine",
  event = "InsertEnter",
  build = "./install.sh",
  dependencies = "hrsh7th/nvim-cmp",
  config = function()
    local tabnine = require("cmp_tabnine.config")

    tabnine:setup({
      max_lines = 1000,
      max_num_results = 3,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = "...",
      show_prediction_strength = false,
      min_percent = 20,
    })
  end,
}
