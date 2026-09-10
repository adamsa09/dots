return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			auto_install = true,
			ensure_installed = {"html", "css", "javascript", "python", "typst"},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		})
	end,
}
