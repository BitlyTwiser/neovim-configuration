return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000, -- load before other plugins so the colorscheme is set first
  config = function()
    require("nightfox").setup({})
    vim.cmd.colorscheme("terafox")
  end,
}
