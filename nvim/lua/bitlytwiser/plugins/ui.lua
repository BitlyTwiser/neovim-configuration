return {
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Statusline (there was none in the original config).
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "nightfox",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
      },
    },
  },
}
