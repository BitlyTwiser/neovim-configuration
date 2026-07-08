return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    -- Servers to install and enable (lspconfig names, not Mason package names).
    local servers = {
      "lua_ls",
      "jsonls",
      "yamlls",
      "gopls",
      "rust_analyzer",
      "ts_ls",
      "eslint",
      "pyright",
      "vue_ls",
    }

    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_enable = true, -- vim.lsp.enable() each installed server
    })

    -- Non-LSP tools (debug adapters + formatter) via Mason.
    require("mason-tool-installer").setup({
      ensure_installed = { "delve", "debugpy", "stylua" },
    })

    -- Advertise blink.cmp completion capabilities to every server.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- Per-server overrides (Neovim 0.11+ vim.lsp.config API).
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    -- Vue (Volar) hybrid mode: ts_ls handles TypeScript inside .vue files via
    -- the @vue/typescript-plugin shipped with the mason vue-language-server.
    local vue_plugin = vim.fn.stdpath("data")
      .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
    vim.lsp.config("ts_ls", {
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_plugin,
            languages = { "vue" },
          },
        },
      },
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
      },
    })

    -- Buffer-local LSP keymaps, set once a server attaches.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("bitlytwiser_lsp_attach", { clear = true }),
      callback = function(event)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Goto definition")
        map("gD", vim.lsp.buf.declaration, "Goto declaration")
        map("gr", vim.lsp.buf.references, "Goto references")
        map("gi", vim.lsp.buf.implementation, "Goto implementation")
        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
      end,
    })

    vim.diagnostic.config({
      virtual_text = true,
      severity_sort = true,
      float = { border = "rounded" },
    })
  end,
}
