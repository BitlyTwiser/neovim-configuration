return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    -- Labels for key prefixes (the individual mappings come from the `desc`
    -- fields on each keymap automatically).
    spec = {
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>t", group = "File tree" },
      { "<leader>x", group = "Diagnostics (Trouble)" },
      { "<leader>d", group = "Debug" },
      { "<leader>r", group = "Rename / refresh / run" },
      { "<leader>a", group = "Agent review" },
      { "g", group = "Goto" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Show buffer keymaps (which-key)",
    },
  },
}
