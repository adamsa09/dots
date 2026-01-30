return {
  'akinsho/toggleterm.nvim', 
  version = "*", 
  config = function()
    local status, toggleterm = pcall(require, 'toggleterm')
    if (not status) then return end

    -- Remove Windows PowerShell configuration - not needed on Linux
    -- Use default shell (bash) on Debian
    
    toggleterm.setup({
      size = 10,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = true,
      direction = 'float',
      -- Optional: Set shell explicitly (usually not needed as it uses $SHELL)
      -- shell = '/bin/bash', -- or vim.o.shell
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal"
        }
      }
    })

    local Terminal = require('toggleterm.terminal').Terminal
    
    -- Node.js terminal
    local node = Terminal:new({ 
      cmd = 'node', 
      hidden = true,
      direction = 'float'
    })

    function RUN_NODE()
      node:toggle()
    end

    -- Python terminal for your debugging workflow
    local python = Terminal:new({ 
      cmd = 'python3', 
      hidden = true,
      direction = 'float'
    })

    function RUN_PYTHON()
      python:toggle()
    end

    -- Additional useful terminals for Debian development
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "double",
      },
      hidden = true,
    })

    function LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    -- Keymaps
    vim.api.nvim_set_keymap('n', ';n', '<Cmd>lua RUN_NODE()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', ';p', '<Cmd>lua RUN_PYTHON()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', ';g', '<Cmd>lua LAZYGIT_TOGGLE()<CR>', { noremap = true, silent = true })

    -- Additional keymaps for terminal management
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    -- Apply terminal keymaps when entering terminal mode
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end
}

