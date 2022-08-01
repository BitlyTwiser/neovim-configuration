require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua", "rust_analyzer", "vue-language-server", "solidity", "delve", "typescript-language-server", "eslint-lsp", "css-lsp", "json-lsp", "gopls", "luacheck", "luaformatter" },
    automatic_installation = true,
 }
)

