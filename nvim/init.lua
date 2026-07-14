-- Entry point. Leader must be set before lazy.nvim loads so plugin
-- keymaps register against the right leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("bitlytwiser.options")
require("bitlytwiser.keymaps")
require("bitlytwiser.lazy")
require("bitlytwiser.agent-review").setup()
