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
      { name = "copilot" },
      { name = "cmp_tabnine" },
      { name = "codecompanion" },
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
      { name = "nerdfont" },
      { name = "luasnip" },
      { name = "lazydev" },
      { name = "render-markdown" },
    }),

    formatting = {
      expandable_indicator = false,
      fields = { "kind", "abbr", "menu" },
      format = function(_, item)
        local icons = require("plugins.cmp.nvim-cmp.icons")
        if icons[item.kind] then
          item.kind = icons[item.kind]
        end
        if item.menu ~= nil then
          -- Limit the length of the menu text to 50
          -- If the length of the menu text is greater than 50, truncate it and add "..."
          if string.len(item.menu) > 30 then
            item.menu = string.sub(item.menu, 1, 30) .. "..."
          end
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
