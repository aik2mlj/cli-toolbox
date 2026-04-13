require("mini.pairs").setup({
  mappings = {
    -- [" "] = { action = "closeopen", pair = "  ", neigh_pattern = "%$%$" },
    ["$"] = { action = "closeopen", pair = "$$" },
  },
})
