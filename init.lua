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

local plugins = {
	{ -- Nice dark mode preview for markdown
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	{
		"briones-gabriel/darcula-solid.nvim",
		dependencies = {
			"rktjmp/lush.nvim",
		},
	},

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
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				filesystem_watchers = {
					enable = true,
				},
				git = {
					enable = false, -- This insure that nvim-tree resheshes all, even if the files are ignored by .gitignore
				},
			})
			-- set mappings
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
		end,
		-- auto_clean = true,
	},

	{
		"nvim-lualine/lualine.nvim",
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
		config = function()
			require("catppuccin").setup()
		end,
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

	-- {
	--   "zbirenbaum/copilot.lua",
	--     config = function()
	--       require("copilot").setup({
	--           -- suggestion = { enabled = false },
	--           -- panel = { enabled = false },
	--       })
	--     end,
	-- },

	{
		"github/copilot.vim",
	},

	-- {
	--   "zbirenbaum/copilot-cmp",
	--   config = function ()
	--     require("copilot_cmp").setup({
	--         sources = {
	--           -- Copilot Source
	--           { name = "copilot", group_index = 2 },
	--           -- Other Sources
	--           { name = "nvim_lsp", group_index = 2 },
	--           { name = "path", group_index = 2 },
	--           { name = "luasnip", group_index = 2 },
	--         },
	--     })
	--   end
	-- },

	{
		"nvim-lua/plenary.nvim",
	},

	{
		"junegunn/fzf",
		config = function()
			-- Only if fzf is not installed, install it!
			if vim.fn.executable("fzf") == 0 then
				vim.fn["fzf#install"]()
			end
		end,
	},

	{
		"rmagatti/session-lens",
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
	{
		"jay-babu/mason-null-ls.nvim",
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = { "stylua", "jq", "lua" },
				automatic_installation = true,
			})
		end,
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		-- config = function()
		--     require("your.null-ls.config") -- require your null-ls config here (example below)
		-- end,
	},
	{ -- Lua language server configuration for nvim
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup()
		end,
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		-- "hrsh7th/nvim-compe",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
		-- NOTE: this is not working correctly
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
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"VonHeikemen/lsp-zero.nvim",
	},

	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
	},

	{
		"LukasPietzschmann/telescope-tabs",
		config = function()
			require("telescope").load_extension("telescope-tabs")
			require("telescope-tabs").setup({
				-- Your custom config :^)
			})
		end,
		dependencies = { "nvim-telescope/telescope.nvim" },
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"nvim-pack/nvim-spectre",
	},

	{
		"dyng/ctrlsf.vim",
	},

	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "flake8" },
				-- lua = { "luacheck" }, -- TODO: replace via stylua, when it is available
				vim = { "vint" },
				sh = { "shellcheck" },
				markdown = { "markdownlint" },
				yaml = { "yamllint" },
				json = { "jsonlint" },
				html = { "tidy" },
				css = { "stylelint" },
				javascript = { "eslint" },
				typescript = { "eslint" },
				svelte = { "eslint" },
				php = { "phpcs" },
				go = { "golangci-lint" },
				rust = { "cargo" },
				graphql = { "graphql" },
				dockerfile = { "hadolint" },
				bash = { "shellcheck" },
			}
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- you can pin a tool to a particular version
					{ "golangci-lint", version = "v1.47.0" },
					-- you can turn off/on auto_update per tool
					{ "bash-language-server", auto_update = true },
					"lua-language-server",
					"vim-language-server",
					"gopls",
					"stylua",
					"shellcheck",
					"editorconfig-checker",
					"gofumpt",
					"golines",
					"gomodifytags",
					"gotests",
					"impl",
					"json-to-struct",
					"luacheck",
					"misspell",
					"revive",
					"shellcheck",
					"shfmt",
					"staticcheck",
					"vint",
				},
				integrations = {
					["mason-lspconfig"] = true,
					["mason-null-ls"] = true,
					["mason-nvim-dap"] = true,
				},
			})
		end,
	},
}

local opts = {}
require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>tac", builtin.autocommands, { desc = "Telescope autocommands" })
vim.keymap.set("n", "<leader>tbb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>tbi", builtin.builtin, { desc = "Telescope builtin" })
vim.keymap.set("n", "<leader>tcs", builtin.colorscheme, { desc = "Telescope colorscheme" })
vim.keymap.set("n", "<leader>tcb", builtin.current_buffer_fuzzy_find, { desc = "Telescope current buffer" })
vim.keymap.set("n", "<leader>tcc", builtin.commands, { desc = "Telescope commands" })
vim.keymap.set("n", "<leader>tch", builtin.command_history, { desc = "Telescope command history" })
vim.keymap.set("n", "<leader>tff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>tht", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>tlg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>tts", builtin.treesitter, { desc = "Telescope treesitter" })
vim.keymap.set("n", "<leader>tdd", builtin.diagnostics, { desc = "Telescope diagnostics" })
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>ttt",
-- 	":Telescope telescope-tabs list_tabs<CR>",
-- 	{ noremap = true, silent = true, desc = "Telescope telescope-tabs list_tabs" }
-- )

-- local function setup_colorscheme()
-- All file types tokyonight
-- vim.api.nvim_command("autocmd BufEnter * colorscheme tokyonight-moon")
-- yaml or yml set tokyonight-moon
-- vim.api.nvim_command("autocmd BufEnter *.yaml,*.yml colorscheme tokyonight-moon")
-- end
-- setup_colorscheme()

require("nvim-autopairs").setup()

require("nvim-treesitter.configs").setup({
	-- modules = {},
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"python",
		"json",
		"yaml",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"svelte",
		"php",
		"go",
		"rust",
		"graphql",
		"dockerfile",
		"bash",
		"lua",
		"json",
		"yaml",
		"html",
		"css",
		"vim",
		"typescript",
		"javascript",
		"svelte",
		"php",
		"go",
		"rust",
		"graphql",
		"dockerfile",
		"bash",
	},
	-- incremental_selection = {
	--   enable = true,
	--   keymaps = {
	--     init_selection = "<CR>",
	--     node_incremental = "<CR>",
	--     scope_incremental = "<S-CR>",
	--     node_decremental = "<BS>",
	--   },
	-- },
	-- sync_install = false,
	-- auto_install = true,
	-- ignore_install = { "javascript" },
	highlight = {
		enable = true,
		disable = function(_, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		additional_vim_regex_highlighting = false,
	},
	--   highlight = {
	--   enable = true,         -- false will disable the whole extension
	--   disable = { "bash" },  -- list of language that will be disabled
	-- },
})

vim.g.loaded_netrw = 1 -- disable netrw at the very start of your init.lua
vim.g.loaded_netrwPlugin = 1

require("mason").setup({ log_level = vim.log.lev })
require("mason").setup({ log_level = vim.log.levels.DEBUG })
-- local ensure_installed_packages = {
-- "pyright",
-- "tsserver",
-- "lua_ls",
-- "lua",
-- "jsonls",
-- "yamlls",
-- "bashls",
-- "dockerls",
-- "gopls",
-- "html",
-- "cssls",
-- "vimls",
-- "clangd",
-- "rust_analyzer",
-- "jdtls",
-- "terraformls",
-- "svelte",
-- "tailwindcss",
-- "graphql",
-- "phpactor",
-- "intelephense",
-- "angularls",
-- "denols",
-- "solargraph",
-- "sqlls",
-- "stylelint_lsp",
-- "vuels",
-- "zls",
-- "hls",
-- }

local lsp_zero = require("lsp-zero")
-- require("mason-lspconfig").setup({
--   ensure_installed = ensure_installed_packages,
--   automatic_installation = true,
--   handlers = {
--     lsp_zero.default_setup,
--   },
-- })

-- lspconfig setup for the language servers
-- NOTE: setup{} or setup({}) has to be used instead of setup() as it is a function call
lsp_zero.on_attach(function(_, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
	vim.keymap.set("n", "<leader>lbdf", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true, desc = "Goto Definition" })
	vim.keymap.set("n", "<leader>lbdc", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true, desc = "Goto Declaration" })
	vim.keymap.set("n", "<leader>lbrf", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true, desc = "Goto References" })
	vim.keymap.set("n", "<leader>lbrn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true, desc = "Rename" })
	vim.keymap.set("n", "<leader>lbhh", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true, desc = "Hover" })
	vim.keymap.set("n", "<leader>lbca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true, desc = "Code Action" })
	vim.keymap.set("n", "<leader>lbsh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true, desc = "Signature Help" })
	vim.keymap.set("n", "<leader>lbtd", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { noremap = true, silent = true, desc = "Type Definition" })
end)
-- lsp_zero.on_attach(function(_, bufnr)
-- 	-- see :help lsp-zero-keybindings
-- 	-- to learn the available actions
-- 	lsp_zero.default_keymaps({ buffer = bufnr })
-- end)

local lspconfig = require("lspconfig")
lspconfig["lua_ls"].setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- Load the language servers
-- local pkgs = ensure_installed_packages
-- for i, lang in ipairs(pkgs) do
--   if lang == "lua_ls" then
--     table.remove(pkgs, i)
--   end
-- end
-- for _, lang in ipairs(ensure_installed_packages) do
--   lspconfig[lang].setup({})
-- end

local cmp = require("cmp")
cmp.setup({
	-- mapping = cmp.mapping.preset.insert({
	-- 	["<Tab>"] = cmp.mapping.confirm({ select = true }),
	-- }),
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Must be here otherwise it will not work and error: 5108 and 5100
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
		-- { name = 'cmdline' },
	},
})
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})

-- configuration
vim.cmd("autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab")
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
vim.cmd("set clipboard+=unnamedplus") -- ensure yanking to system clipboard

-- get python path from which
--python_path_exe = system('which python3')
--vim.cmd("let g:python3_host_prog = )")

-- set no wrapping based on file type
-- vim.cmd([[
--     autocmd FileType help setlocal nowrap
-- ]])
vim.opt.wrap = false

-- Neovim for Python and Node.js installed successfully!
if vim.fn.executable("pip3") == 0 then
	local python_install_cmd = "pip install pynvim"
	os.execute(python_install_cmd)
end

if vim.fn.executable("npm") == 0 then
	local node_install_cmd = "npm install -g neovim"
	os.execute(node_install_cmd)
end

-- Open the last file at the last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd("normal! g'\"")
		end
	end,
})

-- Remove Traling whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

-- Horizontal split resize
vim.keymap.set("n", "<leader>+", [[<C-w>+]], { desc = "Increase horizontal split size" })
vim.keymap.set("n", "<leader>-", [[<C-w>-]], { desc = "Decrease horizontal split size" })

-- Define the function to remove the quickfix item
RemoveQFItem = function() -- luacheck: ignore
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
vim.cmd([[
    augroup RemoveQFMapping
        autocmd!
        autocmd FileType qf nnoremap <buffer> dd :RemoveQFItem<CR>
    augroup END
]])

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.api.nvim_command("colorscheme tokyonight-moon")
