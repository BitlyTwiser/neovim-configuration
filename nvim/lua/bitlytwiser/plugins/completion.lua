return {
  "saghen/blink.cmp",
  -- Use a release tag so lazy downloads the prebuilt fuzzy-matcher binary
  -- (no local Rust/cargo toolchain required).
  version = "1.*",
  event = "InsertEnter",
  dependencies = {
    { "L3MON4D3/LuaSnip", version = "v2.*" },
    "rafamadriz/friendly-snippets",
  },
  opts = {
    keymap = { preset = "default" }, -- <C-y> confirm, <C-n>/<C-p> select, <C-space> menu/docs
    appearance = { nerd_font_variant = "mono" },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
