return {
  "nvim-treesitter/nvim-treesitter",
  -- The `master` branch is frozen and does NOT support Neovim 0.12 (it crashes the
  -- highlighter with "attempt to call method 'range' (a nil value)"). Use the maintained
  -- `main` branch, which targets Neovim 0.12+ but has a different, module-less API:
  -- parsers are installed via require("nvim-treesitter").install(), and highlighting /
  -- indentation are enabled per-buffer through Neovim core APIs in a FileType autocmd.
  branch = "main",
  lazy = false, -- eager load so the FileType autocmd is armed before the first buffer
  build = ":TSUpdate",
  config = function()
    local parsers = {
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
      "yaml",
      "html",
      "css",
      "bash",
      "markdown",
      "markdown_inline",
      "toml",
    }

    -- Install/update any missing parsers (async; a no-op for already-installed ones).
    require("nvim-treesitter").install(parsers)

    -- The `main` branch has no separate `jsonc` parser; reuse the `json` parser for
    -- jsonc buffers (tsconfig.json, .jsonc, ...) so they still get treesitter highlighting.
    vim.treesitter.language.register("json", "jsonc")

    -- Enable treesitter highlighting + indentation for any buffer whose filetype has an
    -- installed parser. pcall no-ops on filetypes without a parser, so no explicit
    -- filetype list is needed (parser names like markdown_inline/gomod are not filetypes).
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        if not pcall(vim.treesitter.start, buf) then
          return -- no parser for this filetype; leave default syntax highlighting
        end
        -- Treesitter indentation (experimental upstream). Match the old config, which
        -- disabled treesitter indent for yaml.
        if vim.bo[buf].filetype ~= "yaml" then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
