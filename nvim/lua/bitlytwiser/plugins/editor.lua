return {
  -- File explorer.
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeClose", "NvimTreeRefresh" },
    keys = {
      { "<leader>tr", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
      { "<leader>tf", "<cmd>NvimTreeFindFile<CR>", desc = "Find file in tree" },
      { "<leader>ct", "<cmd>NvimTreeClose<CR>", desc = "Close file tree" },
      { "<leader>rt", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh file tree" },
    },
    config = function()
      -- The old view.mappings / nvim_tree_callback API was removed; keymaps are
      -- now registered through on_attach.
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        update_focused_file = { enable = true, update_root = true },
        view = { width = 30, side = "left" },
        renderer = {
          root_folder_label = ":t",
          icons = {
            glyphs = {
              git = {
                unstaged = "",
                staged = "S",
                unmerged = "",
                renamed = "➜",
                untracked = "U",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        diagnostics = { enable = true, show_on_dirs = true },
        -- Show hidden files by default. Dotfiles already show (dotfiles = false), but
        -- git-ignored entries are hidden by default (git_ignored = true) - set both
        -- false so nothing is hidden. Toggle at runtime with `H` (dotfiles) / `I` (ignored).
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
      })
    end,
  },

  -- Terminal + lazygit.
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { [[<c-\>]], desc = "Toggle terminal" },
      {
        "<leader>gg",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" }):toggle()
        end,
        desc = "LazyGit",
      },
    },
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      float_opts = { border = "curved" },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      -- Terminal-mode navigation keymaps.
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          local o = { buffer = 0, noremap = true }
          vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], o)
          vim.keymap.set("t", "jk", [[<C-\><C-n>]], o)
          vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], o)
          vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], o)
          vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], o)
          vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], o)
        end,
      })
    end,
  },

  -- Diagnostics list (Trouble v3 command syntax).
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
      { "gR", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP references (Trouble)" },
    },
    opts = {},
  },

  -- Auto-close pairs.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
      },
      disable_filetype = { "TelescopePrompt" },
      fast_wrap = {},
    },
  },
}
