local function setup()
  local cmp = require("cmp")
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-1),
      ["<C-f>"] = cmp.mapping.scroll_docs(1),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<M-c>"] = cmp.mapping.abort(),
    }),

    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },

    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "cmp_tabnine" },
      { name = "path" },
      { name = "nerdfont" },
      { name = "luasnip" },
      { name = "lazydev" },
    }),

    ---@diagnostic disable-next-line: missing-fields
    formatting = {
      format = function(_, item)
        local icons = require("plugins.cmp.nvim-cmp.icons")
        if icons[item.kind] then
          item.kind = icons[item.kind] .. item.kind
        end
        return item
      end,
    },
  })
end

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {},
  config = setup,
}
