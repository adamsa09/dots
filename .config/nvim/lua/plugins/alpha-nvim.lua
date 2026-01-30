return {
    'goolord/alpha-nvim',
    dependencies = {
        'echasnovski/mini.icons',
        'nvim-lua/plenary.nvim'
    },
    config = function ()
        local theta = require'alpha.themes.theta'
        
        -- Fix the configuration button command
        for _, button in ipairs(theta.config.layout) do
            if button.val and type(button.val) == "table" then
                for _, item in ipairs(button.val) do
                    if item.opts and item.opts.shortcut == "c" then
                        item.on_press = function()
                            vim.cmd("cd " .. vim.fn.stdpath("config"))
                        end
                    end
                end
            end
        end
        
        require'alpha'.setup(theta.config)
    end
};

