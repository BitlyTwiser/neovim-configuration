-- General, plugin-independent keymaps. Plugin-specific keymaps live in each
-- plugin's spec (`keys = ...`) so lazy.nvim can load the plugin on demand, and
-- LSP keymaps are set from an LspAttach autocmd in plugins/lsp.lua.
local map = vim.keymap.set

-- Clear search highlight.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Netrw file explorer split (kept from the original config).
map("n", "<leader>bk", "<cmd>Vex<CR>", { desc = "Open netrw split" })

-- Window navigation.
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Keep the cursor centered when scrolling / searching.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
