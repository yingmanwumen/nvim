local function on_attach(buffer)
  local gs = package.loaded.gitsigns
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
  end

  map("n", "]g", gs.next_hunk, "Next Hunk")
  map("n", "[g", gs.prev_hunk, "Prev Hunk")
  map("n", "<leader>gi", gs.preview_hunk_inline, "Inline Preview Hunk")
  map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
  map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle Git Blame")
  map("n", "<leader>gl", gs.toggle_linehl, "Toggle Line highlight")
  map("n", "<leader>gd", gs.diffthis, "Git Diff")
  map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
end

return {
  "lewis6991/gitsigns.nvim",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        changedelete = { text = "┃" },
        untracked = { text = "┃" },
        delete = { text = "" },
        topdelete = { text = "" },
      },
      current_line_blame = true,
      on_attach = on_attach,
      attach_to_untracked = true,
      current_line_blame_formatter = "󰘬 <author>, <author_time:%R> - <summary>",
    })
  end,
}
