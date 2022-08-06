local status_ok, dap_go = pcall(require, 'dap-go')
if not status_ok then
  return
end

local opts = { noremap = true }
vim.g.mapleader = " "  
vim.api.nvim_set_keymap('n', '<silent><F5>', ":require'dap'.continue()<CR>", opts)
vim.api.nvim_set_keymap('n', '<silent><F10>', ":require'dap'.step_over()<CR>", opts)
vim.api.nvim_set_keymap('n', '<silent><F11>', ":require'dap'.step_into()<CR>", opts)
vim.api.nvim_set_keymap('n', '<silent><F12>', ":require'dap'.step_out()<CR>", opts)
dap_go.setup()
