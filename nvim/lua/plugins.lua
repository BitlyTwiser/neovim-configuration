return require("packer").startup(function()
use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
  requires = { {'nvim-lua/plenary.nvim'} }
}
use {
 'nvim-treesitter/nvim-treesitter',
 run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
}
end)
