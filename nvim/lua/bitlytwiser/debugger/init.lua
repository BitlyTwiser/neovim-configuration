local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

local remap = require("bitlytwiser.keymap")
local nnoremap = remap.nnoremap

daptext.setup({
  enable = true,
  enable_commands = true
})

dapui.setup()

vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<Leader>drc", ":lua require('dap').repl.close()<CR>", { noremap=true})
vim.api.nvim_set_keymap("n", "<Leader>dro", ":lua require('dap').repl.open()<CR>", { noremap=true})
vim.api.nvim_set_keymap('n', '<leader>oui', ":lua require('dapui').open()<CR>", { noremap=true })

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open(1)
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

require("bitlytwiser.debugger.go");
require("bitlytwiser.debugger.ruby");

nnoremap("<Home>", function()
    dapui.toggle(1)
end)
nnoremap("<End>", function()
    dapui.toggle(2)
end)

nnoremap("<leader><leader>", function()
    dap.close()
end)

nnoremap("<Up>", function()
    dap.continue()
end)
nnoremap("<Down>", function()
    dap.step_over()
end)
nnoremap("<Right>", function()
    dap.step_into()
end)
nnoremap("<Left>", function()
    dap.step_out()
end)
nnoremap("<Leader>b", function()
    dap.toggle_breakpoint()
end)
nnoremap("<Leader>B", function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
nnoremap("<leader>rc", function()
    dap.run_to_cursor()
end)
