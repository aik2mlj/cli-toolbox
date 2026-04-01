return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "fish",
      },
      indent = {
        enable = true,
        disable = { "typst" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>/", false },
    },
  },
  {
    "nvim-mini/mini.pairs",
    opts = {
      skip_next = [=[[%w%%%'%[%"%.%`]]=],
    },
  },
  {
    "snacks.nvim",
    opts = {
      -- disable scroll animation
      scroll = { enabled = false },
    },
  },
}
