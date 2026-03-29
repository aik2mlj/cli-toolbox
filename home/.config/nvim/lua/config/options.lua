-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.scrolloff = 15
vim.opt.relativenumber = false
vim.opt.spell = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4 -- A TAB character looks like 4 spaces
vim.opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character

-- vim.g.clipboard = "osc52"
vim.opt.clipboard = "unnamedplus"

vim.g.lazyvim_python_lsp = "basedpyright"
-- vim.g.lazyvim_python_lsp = "pyrefly"
-- vim.g.lazyvim_python_lsp = "ty"
