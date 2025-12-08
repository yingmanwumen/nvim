return {
  "PLAZMAMA/bunnyhop.nvim",
  event = "VeryLazy",
  dependencies = {
    "zbirenbaum/copilot.lua",
  },
  keys = {
    {
      "<C-h>",
      function()
        require("bunnyhop").hop()
      end,
      desc = "[H]op to predicted location.",
    },
  },
  opts = {
    -- Currently the only options are "copilot" and "huggingface"
    adapter = "copilot",
    -- Model to use for chosen provider.
    -- To know what models are available for chosen adapter,
    -- run `:lua require("bunnyhop.adapters.{adapter}").get_models()`
    -- model = "gpt-4o",
    model = "gpt-4.1",
    -- Copilot doesn't use the API key.
    --Hugging Face does and its stored in an environment variable.
    -- Example where `HF_API_KEY` is the name of the environment variable:
    -- `api_key = "HF_API_KEY"`
    api_key = "",
    -- Max width the preview window will be.
    -- Here for if you want to make the preview window bigger/smaller.
    max_prev_width = 40,
    -- This is an option to enable LOCAL data collection.
    -- Can be used to assess the accuracy of the predictions and will be used for better context creation.
    -- Currently its disabled by default to respect user privacy but will be required later for better performance and planned advanced features.
    collect_data = true,
  },
}
