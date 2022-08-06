require('bitlytwiser.plugins')
require('bitlytwiser.telescope')
require('bitlytwiser.bufferline')
require('bitlytwiser.nvim-tree')
require('bitlytwiser.toggleterm')
require('bitlytwiser.treesitter')
require('bitlytwiser.mason')
require('bitlytwiser.autopairs')
require('bitlytwiser.cmp')
require('bitlytwiser.mason-lsp')
require('bitlytwiser.tabnine')
require('bitlytwiser.debugger')
require('bitlytwiser.trouble')
require('bitlytwiser.lspcolors')
require('bitlytwiser.lsp')
require('bitlytwiser.functions')

vim.cmd([[
 set guicursor=
 set scrolloff=8
 set number     
 set relativenumber
 set expandtab     
 set tabstop=2 softtabstop=2
 set shiftwidth=2 
 set smartindent 
 set clipboard=unnamed
 colorscheme terafox
 au TextYankPost * silent! lua vim.highlight.on_yank()
]])                

vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<leader>bk", ":Vex<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><CR>", ":luafile ~/.config/nvim/init.lua<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files({ hidden = true })<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep({ hidden = true })<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fbuff", "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope file_browser<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tr", ":NvimTreeToggle<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tf", ":NvimTreeFindFile<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ct", ":NvimTreeClose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>rt", ":NvimTreeRefresh<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>td",":lua require('dap-go').debug_test()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap=true, silent=true, buffer=bufnr })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap=true, silent=true, buffer=bufnr })
vim.api.nvim_set_keymap("n", "[b", ":BufferLineCycleNext<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "]b", ":BufferLineCyclePrev<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>bln", ":BufferLineCycleNext<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>blp", ":BufferLineCyclePrev<CR>", { noremap = true })
