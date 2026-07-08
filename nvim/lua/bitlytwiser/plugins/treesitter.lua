return {
  "nvim-treesitter/nvim-treesitter",
  -- Pin the classic `master` API (configs.setup with highlight/indent modules).
  -- The default `main` branch is a rewrite with an incompatible API.
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdate", "TSInstall", "TSInstallInfo" },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Curated list instead of "all" (which is heavy and needs the tree-sitter CLI).
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "go",
        "gomod",
        "gosum",
        "rust",
        "typescript",
        "javascript",
        "tsx",
        "vue",
        "python",
        "json",
        "jsonc",
        "yaml",
        "html",
        "css",
        "bash",
        "markdown",
        "markdown_inline",
        "toml",
      },
      auto_install = false,
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = { "yaml" },
      },
    })
  end,
}
