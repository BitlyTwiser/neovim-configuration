# neovim-configuration

A modern Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim).
Targets Neovim **0.11+** (developed on 0.12).

## Features

- **Plugin manager:** lazy.nvim (auto-bootstraps on first launch; `lazy-lock.json` pins versions)
- **Fuzzy finding:** Telescope + file-browser, using ripgrep for live grep
- **Syntax:** nvim-treesitter
- **LSP:** mason + mason-lspconfig + nvim-lspconfig for Go, Rust, TypeScript/JavaScript,
  Python, Vue, Lua, JSON, YAML
- **Completion:** blink.cmp (+ LuaSnip snippets)
- **Debugging:** nvim-dap with dap-ui, virtual text, Go (delve) and Python (debugpy)
- **UI:** nightfox (`terafox`) colorscheme, lualine statusline, nvim-tree file explorer,
  trouble.nvim diagnostics
- **Extras:** toggleterm with a lazygit binding (`<leader>gg`), autopairs

## Setup

1. Install [Neovim 0.11+](https://github.com/neovim/neovim/releases).
2. Copy this repo's `nvim/` directory to your Neovim config location:
   - Linux/macOS: `~/.config/nvim`
   - Windows: `~/AppData/Local/nvim`
3. Launch `nvim`. lazy.nvim bootstraps itself and installs all plugins on first run.
4. Run `:Mason` to confirm language servers and debug adapters installed, and
   `:checkhealth` to verify everything is green.

## Dependencies

- [ripgrep](https://github.com/BurntSushi/ripgrep) - required for Telescope live grep
- A C compiler + `make` - to build treesitter parsers
- `node`/`npm` - for the TypeScript, Vue, ESLint, JSON, and YAML language servers
- Language toolchains as needed: `go`, `cargo`/`rustc`, `python3`
- Optional: [lazygit](https://github.com/jesseduffield/lazygit) for `<leader>gg`

## Fonts

A [Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases) (v3.x) is required for
icons in the file tree, statusline, and completion menu.

## Key bindings

Leader is `<Space>`.

| Mapping         | Action                        |
| --------------- | ----------------------------- |
| `<leader>ff`    | Find files (Telescope)        |
| `<leader>fg`    | Live grep (ripgrep)           |
| `<leader>fbuff` | Buffers                       |
| `<leader>fb`    | File browser                  |
| `<leader>tr`    | Toggle file tree              |
| `gd` / `gD`     | Goto definition / declaration |
| `K`             | Hover documentation           |
| `<leader>rn`    | Rename symbol                 |
| `<leader>ca`    | Code action                   |
| `<leader>xx`    | Diagnostics list (Trouble)    |
| `<F5>`          | Debug: continue               |
| `<leader>b`     | Debug: toggle breakpoint      |
| `<leader>gg`    | LazyGit                       |
| `` <c-\> ``     | Toggle terminal               |
