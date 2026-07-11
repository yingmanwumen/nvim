return {
  "Exafunction/windsurf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local curl = require("plenary.curl")
    local cache_dir = vim.fn.stdpath("cache") .. "/plenary-curl"

    vim.fn.mkdir(cache_dir, "p", "448")

    local function add_header_dump(opts)
      opts = opts or {}
      if opts.dump == nil then
        opts.dump = {
          "-D",
          cache_dir .. "/" .. vim.fn.fnamemodify(vim.fn.tempname(), ":t"),
        }
      end
      return opts
    end

    local curl_get = curl.get
    curl.get = function(url, opts)
      return curl_get(url, add_header_dump(opts))
    end

    local curl_post = curl.post
    curl.post = function(url, opts)
      return curl_post(url, add_header_dump(opts))
    end

    require("codeium").setup({
      enable_cmp_source = true,
      virtual_text = {
        enabled = false,
        manual = true,
      },
    })
  end,
}
