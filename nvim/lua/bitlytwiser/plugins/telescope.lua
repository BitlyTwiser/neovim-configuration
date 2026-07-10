return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    -- <leader>fg is live_grep, which shells out to ripgrep.
    -- hidden = show dotfiles; no_ignore = also show git-ignored files (e.g. .env,
    -- .env.development). node_modules/.git are still filtered via defaults.file_ignore_patterns.
    { "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true, no_ignore = true }) end, desc = "Find files" },
    { "<leader>fg", function() require("telescope.builtin").live_grep({ hidden = true }) end, desc = "Live grep (ripgrep)" },
    { "<leader>fbuff", function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
    { "<leader>fb", "<cmd>Telescope file_browser<CR>", desc = "File browser" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        file_ignore_patterns = { "node_modules", "%.git/" },
      },
    })
    telescope.load_extension("file_browser")
  end,
}
