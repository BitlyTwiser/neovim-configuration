return {
  -- Git diff / merge / file-history viewer. Used to review agent (Claude Code,
  -- etc.) edits without leaving Neovim; bitlytwiser/agent-review.lua keeps an
  -- open view in sync as files change on disk.
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    keys = {
      {
        "<leader>av",
        function()
          if require("diffview.lib").get_current_view() then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end,
        desc = "Toggle Diffview (agent view)",
      },
      { "<leader>ah", "<cmd>DiffviewFileHistory %<CR>", desc = "File history (current file)" },
      { "<leader>ab", "<cmd>DiffviewOpen main...HEAD<CR>", desc = "Diff branch vs main" },
    },
    opts = {},
  },
}
