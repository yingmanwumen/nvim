return {
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  },
  config = function()
    require('lspsaga').setup({
      diagnostic = {
      },
      lightbulb = {
        enable = true,
        sign = true,
        virtual_text = false,
      },
    })

    local function bind(lhs, rhs, desc, mode)
      if mode == nil then
        mode = 'n'
      end
      vim.keymap.set(mode, lhs, rhs, {
        desc = desc, silent = true
      })
    end

    bind('[d', "<Cmd>Lspsaga diagnostic_jump_prev<CR>", 'Go to previous diagnostic')
    bind(']d', "<Cmd>Lspsaga diagnostic_jump_next<CR>", 'Go to next diagnostic')
  end,
}
