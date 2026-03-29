-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "x" }, "H", "g^")
vim.keymap.set({ "n", "x" }, "L", "g$")
vim.keymap.set({ "n", "x" }, "J", "5gj")
vim.keymap.set({ "n", "x" }, "K", "5gk")
vim.keymap.set({ "n", "x" }, "<leader>j", "J", { desc = "Join Lines" })

vim.keymap.set({ "n", "i" }, "<M-h>", "<esc><cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set({ "n", "i" }, "<M-l>", "<esc><cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set({ "n", "i" }, "<M-p>", "<esc><cmd>b#<cr>", { desc = "Last Buffer" })
vim.keymap.set({ "n", "i" }, "<M-H>", "<esc><cmd>BufferLineMovePrev<cr>", { desc = "Move buffer prev" })
vim.keymap.set({ "n", "i" }, "<M-L>", "<esc><cmd>BufferLineMoveNext<cr>", { desc = "Move buffer next" })
vim.keymap.set({ "n", "i" }, "<C-q>", "<esc><cmd>q<cr>")

vim.keymap.set("n", "<M-J>", ":t .<CR>", { silent = true })
vim.keymap.set("n", "<M-K>", ":t .-1<CR>", { silent = true })
vim.keymap.set("n", "<M-q>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
-- vim.keymap.set("n", "<leader>d", function()
--   Snacks.bufdelete()
-- end, { desc = "Delete Buffer" })
vim.keymap.set("n", "U", "<c-r>")
vim.keymap.set("n", "<leader>r", ":%s//g<Left><Left>", { desc = "Global Replace" })
vim.keymap.set("n", "<leader>/", "gcc", { desc = "Toggle Comment", remap = true })
vim.keymap.set("n", "<leader>A", "<esc>ggVG", { desc = "Select All" })
vim.keymap.set("n", "<leader><enter>", "<cmd>FzfLua resume<cr>", { desc = "Resume last search" })

vim.keymap.set("x", "<M-J>", ":t'><CR>gv", { silent = true })
vim.keymap.set("x", "<M-K>", ":t-1<CR>gv", { silent = true })
vim.keymap.set("x", "<leader>f", 'y<ESC>/<c-r>"<CR>', { desc = "Search Selected" })
vim.keymap.set("x", "<leader>F", "<cmd>FzfLua grep_visual<cr>", { desc = "Global Search Selected" })
vim.keymap.set("x", "<leader>r", ":s//g<Left><Left>", { desc = "Replace in Selected" })
vim.keymap.set("x", "<leader>/", "gc", { desc = "Toggle Comment", remap = true })

-- terminal in cwd by default
vim.keymap.set({ "n", "t" }, "<c-/>", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })

if vim.g.neovide then
  vim.keymap.set("v", "<C-S-C>", '"+y') -- Copy
  vim.keymap.set("n", "<C-S-V>", '"+p') -- Paste normal mode
  vim.keymap.set("v", "<C-S-V>", '"+p') -- Paste visual mode
  vim.keymap.set("c", "<C-S-V>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<C-S-V>", '<ESC>"+pi') -- Paste insert mode
end
