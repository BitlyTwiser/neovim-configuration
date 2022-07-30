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
use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
}
	use({ "hrsh7th/nvim-cmp", commit = "df6734aa018d6feb4d76ba6bda94b1aeac2b378a" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer", commit = "62fc67a2b0205136bc3e312664624ba2ab4a9323" }) -- buffer completions
	use({ "hrsh7th/cmp-path", commit = "466b6b8270f7ba89abd59f402c73f63c7331ff6e" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip", commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp", commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" })
	use({ "hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" })
end)
