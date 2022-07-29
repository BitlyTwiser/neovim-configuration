require('plugins')

vim.cmd([[
 set guicursor=
 set scrolloff=8
 set number     
 set relativenumber
 set expandtab     
 set tabstop=4 softtabstop=4
 set shiftwidth=4           
 set smartindent 
 colorscheme desert
 au TextYankPost * silent! lua vim.highlight.on_yank()
 let mapleader = " "                                  
]])                

vim.api.nvim_set_keymap("n", "<leader>bk", ":Vex<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><CR>", ":luafile ~/.config/nvim/init.lua<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap = true })
