-- Editor options (modernized from the old init.lua vim.cmd block).
local opt = vim.opt

opt.guicursor = ""
opt.scrolloff = 8
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250

-- Highlight yanked text (vim.highlight.on_yank was renamed to vim.hl.on_yank).
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("bitlytwiser_highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
