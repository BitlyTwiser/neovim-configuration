local use = require('packer').use

return require("packer").startup(function()
use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
  requires = { {'nvim-lua/plenary.nvim'} }
}
use {
 'nvim-treesitter/nvim-treesitter',
 run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
}
use { "nvim-telescope/telescope-file-browser.nvim" }
use "EdenEast/nightfox.nvim"
use {
  'kyazdani42/nvim-tree.lua',
  requires = {
    'kyazdani42/nvim-web-devicons', -- optional, for file icons
  },
  tag = 'nightly' -- optional, updated every week. (see issue #1193)
}
use 'wbthomason/packer.nvim' -- Package manager
use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
use 'mfussenegger/nvim-dap'
use { "williamboman/mason.nvim" }
use {"akinsho/toggleterm.nvim", tag = 'v2.*', config = function()
  require("toggleterm").setup()
end}
end)
