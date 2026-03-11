return {
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  end,
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "html", "emmet_language_server", "cssls", "ts_ls", "lua_ls" },
        automatic_installation = true,
        automatic_enable = {
          exclude = {},
        },
        handlers = {
          -- Default handler configures and enables servers
          function(server_name)
            local server_config = {
              capabilities = capabilities,
              on_attach = on_attach,
            }

            if server_name == "lua_ls" then
              server_config.settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = { globals = { "vim" } },
                  workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                  telemetry = { enable = false },
                },
              }
            elseif server_name == "html" then
              server_config.filetypes = { "html", "htmldjango" }
              server_config.init_options = {
                configurationSection = { "html", "css", "javascript" },
                embeddedLanguages = {
                  css = true,
                  javascript = true,
                },
                provideFormatter = true,
              }
            elseif server_name == "emmet_language_server" then
              server_config.filetypes = {
                "css", "html", "htmldjango", "javascript",
                "javascriptreact", "typescriptreact", "vue"
              }
            end

            vim.lsp.config(server_name, server_config)
            vim.lsp.enable(server_name)
          end,

          -- Pyright: use active venv if available, fallback to system python3
          ["pyright"] = function()
            local venv_path = os.getenv("VIRTUAL_ENV")
            local python_path = venv_path and (venv_path .. "/bin/python") or vim.fn.exepath("python3")

            vim.lsp.config("pyright", {
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                python = {
                  pythonPath = python_path,
                  venvPath = venv_path and vim.fn.fnamemodify(venv_path, ":h") or nil,
                  venv = venv_path and vim.fn.fnamemodify(venv_path, ":t") or nil,
                },
              },
            })
            vim.lsp.enable("pyright")
          end,
        },
      })
    end,
  },
}
