return {
  {
    "rebelot/kanagawa.nvim",
    opts = function()
      if not vim.g.neovide then
        return {
          transparent = true,
          colors = {
            theme = {
              all = {
                ui = {
                  bg_gutter = "none",
                },
              },
            },
          },
        }
      end
    end,
  },
  {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>o",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
      {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
    },
    opts = {
      floating_window_scaling_factor = 0.6,
      -- yazi_floating_window_winblend = 100,
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      options = {
        show_source = {
          enabled = true, -- Enable showing source names
          if_many = true, -- Only show source if multiple sources exist for the same diagnostic
        },
      },
    },
  },
}
