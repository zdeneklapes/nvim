-- luacheck: ignore vim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.wo.relativenumber = true
vim.wo.number = true
vim.cmd("set notimeout nottimeout")
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.g.mapleader = "\\"
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- set no wrapping based on file type
-- vim.cmd([[
--     autocmd FileType help setlocal nowrap
-- ]])
vim.opt.wrap = false

-- Open the last file at the last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.api.nvim_exec("normal! g'\"", false)
		end
	end,
})

-- Remove Traling whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

-- Horizontal split resize
vim.keymap.set("n", "<leader>+", [[<C-w>+]], {})
vim.keymap.set("n", "<leader>-", [[<C-w>-]], {})

-- Define the function to remove the quickfix item
local RemoveQFItem = function() -- luacheck: ignore
	local curqfidx = vim.fn.line(".") - 1
	local qfall = vim.fn.getqflist()
	table.remove(qfall, curqfidx + 1)
	vim.fn.setqflist(qfall, "r")
	vim.cmd(tostring(curqfidx + 1) .. "cfirst")
	vim.cmd("copen")
end

-- Create a command to call the function
vim.cmd("command! RemoveQFItem lua RemoveQFItem()")

-- Use `map <buffer>` to only map `dd` in the quickfix window
vim.api.nvim_exec(
	[[
    augroup RemoveQFMapping
        autocmd!
        autocmd FileType qf nnoremap <buffer> dd :RemoveQFItem<CR>
    augroup END
]],
	false
)

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local plugins = {

	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_enabled = true,
				auto_session_enable_last_session = true,
				auto_session_last_session_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
				-- table: Config for handling the DirChangePre and DirChanged autocmds, can be set to nil to disable altogether
				cwd_change_handling = {
					-- boolean: restore session for upcoming cwd on cwd change
					restore_upcoming_session = true,
					-- function: This is called after auto_session code runs for the `DirChangedPre` autocmd
					pre_cwd_changed_hook = nil,
					-- function: This is called after auto_session code runs for the `DirChanged` autocmd
					post_cwd_changed_hook = nil,
				},
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		keys = { {
			"n",
			"<leader>e",
			":NvimTreeToggle<CR>",
			{ silent = true },
		} },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({})
		end,
	},

	{
		"rmagatti/session-lens",
		requires = {
			"rmagatti/auto-session",
			-- 'nvim-telescope/telescope.nvim' -- NOTE: needed but mentioned above
		},
		config = function()
			require("session-lens").setup({--[[your custom config--]]
			})
		end,
	},

	{

		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},

	{
		"nvim-lua/popup.nvim",
	},

	{
		"windwp/nvim-autopairs",
	},

	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},

	{
		"github/copilot.vim",
	},

	{
		"nvim-lua/plenary.nvim",
	},

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				enabled = vim.fn.executable("make") == 1,
				config = function()
					require("telescope").load_extension("fzf")
					require("telescope").load_extension("session-lens")
				end,
			},
		},
		setup = function()
			-- Install ripgrep based on the operating system
			local install_cmd
			if vim.fn.has("mac") == 1 then
				-- macOS, use Homebrew
				install_cmd = "brew install ripgrep"
			elseif vim.fn.has("unix") == 1 then
				-- Linux, use apt-get
				install_cmd = "sudo apt-get install ripgrep"
			else
				-- Unsupported OS, prompt the user to manually install
				print("Unsupported operating system. Please install ripgrep manually.")
				return
			end

			-- local install = vim.fn.input("Do you want to install ripgrep (rg)? [y/N] ")
			-- if install == "y" then
			vim.cmd("!" .. install_cmd)
			-- end

			-- Lazy-load Telescope
			vim.cmd("packadd plenary.nvim")
			vim.cmd("packadd popup.nvim")
			vim.cmd("packadd telescope.nvim")
			require("telescope").setup({})
		end,
	},

	{
		"smartpde/telescope-recent-files",
	},

	{
		"nvim-telescope/telescope-file-browser.nvim",
	},

	{
		"nvim-treesitter/nvim-treesitter",
	},

	{
		"nvim-tree/nvim-tree.lua",
	},

	{
		"nvim-tree/nvim-web-devicons",
	},

	{
		"nvimdev/hlsearch.nvim",
		event = "BufRead",
		config = function()
			require("hlsearch").setup()
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"neovim/nvim-lspconfig",
	},
	{ -- Automatically install LSPs to stdpath for neovim
		"williamboman/mason.nvim",
	},
	{ -- ibid
		"williamboman/mason-lspconfig.nvim",
	},
	{ -- Lua language server configuration for nvim
		"folke/neodev.nvim",
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
		-- TODO [NOTE] : this is not working correctly
		--     config = function()
		--         require('cmp').setup{
		--             sources = {
		--                 { name = 'nvim_lsp' },
		--                 { name = 'buffer' },
		--                 { name = 'path' },
		--                 { name = 'cmdline' },
		--             }
		--         }
		--     end
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}

local opts = {}
require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>tac", builtin.autocommands, {})
vim.keymap.set("n", "<leader>tbb", builtin.buffers, {})
vim.keymap.set("n", "<leader>tbi", builtin.builtin, {})
vim.keymap.set("n", "<leader>tcs", builtin.colorscheme, {})
vim.keymap.set("n", "<leader>tcb", builtin.current_buffer_fuzzy_find, {})
vim.keymap.set("n", "<leader>tcc", builtin.commands, {})
vim.keymap.set("n", "<leader>tch", builtin.command_history, {})
vim.keymap.set("n", "<leader>tff", builtin.find_files, {})
vim.keymap.set("n", "<leader>tht", builtin.help_tags, {})
vim.keymap.set("n", "<leader>tlg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>tts", builtin.treesitter, {})

require("catppuccin").setup()
vim.cmd.colorscheme("tokyonight")

require("nvim-autopairs").setup()

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- List of parsers to ignore installing (or "all")
	ignore_install = { "javascript" },

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers",
	-- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- disable = { "c", "rust" },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(_, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})

vim.g.loaded_netrw = 1 -- disable netrw at the very start of your init.lua
vim.g.loaded_netrwPlugin = 1

require("neodev").setup()

require("mason").setup({
	log_level = vim.log.levels.DEBUG,
})
local ensure_installed_packages = {
	"pyright",
	"tsserver",
	"lua_ls",
	"jsonls",
	"yamlls",
	"bashls",
	"dockerls",
	"gopls",
	"html",
	"cssls",
	"vimls",
	"clangd",
	"rust_analyzer",
	"jdtls",
	"terraformls",
	"svelte",
	"tailwindcss",
	"graphql",
	"phpactor",
	"intelephense",
	"angularls",
	"denols",
	"solargraph",
	"sqlls",
	"stylelint_lsp",
	"vuels",
	"zls",
}
require("mason-lspconfig").setup({
	ensure_installed = ensure_installed_packages,
	automatic_installation = true,
})

require("nvim-tree").setup()

-- lspconfig setup for the language servers
-- TODO[NOTE] : setup{} or setup({}) has to be used instead of setup() as it is a function call
require("lspconfig")["lua_ls"].setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- Load the language servers
local pkgs = ensure_installed_packages
for i, lang in ipairs(pkgs) do
	if lang == "lua_ls" then
		table.remove(pkgs, i)
	end
end
for _, lang in ipairs(ensure_installed_packages) do
	require("lspconfig")[lang].setup({})
end
