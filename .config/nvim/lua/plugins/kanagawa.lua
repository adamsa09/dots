return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('kanagawa').setup({
      compile = false,             -- Enable compiling the colorscheme
      undercurl = true,            -- Enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,         -- Do not set background color
      dimInactive = false,         -- Dim inactive window backgrounds
      terminalColors = true,       -- Define vim.g.terminal_color_{0,17}
      colors = {                   -- Add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = { ui = { bg_gutter = "none" } } },
      },
      overrides = function(colors) -- Add/modify highlights
        return {}
      end,
      theme = "dragon",            -- Load "dragon" theme explicitly
      background = {               -- Map the value of 'background' option to a theme
        dark = "dragon",           -- Use dragon for dark background
        light = "lotus"
      },
    })

    -- Setup must be called before loading the colorscheme
    vim.cmd("colorscheme kanagawa-dragon")
  end,
}

