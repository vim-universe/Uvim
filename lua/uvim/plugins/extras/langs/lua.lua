return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "lua" } },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function(_, opts)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
      })

      lspconfig.lua_ls.setup({ capabilities = capabilities })
    end,
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, "lua")
    end,
  },

  -- Formatting and Linting
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    config = function(_, opts)
      require("mason").setup()
      require("mason-null-ls").setup({
        ensure_installed = { "stylua", "luacheck" },
      })

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = vim.tbl_deep_extend("force", opts.sources or {}, {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.diagnostics.luacheck.with({
            extra_args = { "--globals", "vim" },
          }),
        }),
      })
    end,
  },
}