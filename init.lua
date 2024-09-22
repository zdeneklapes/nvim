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

local MASON = {
	lsp = {
		-- Lua
		"lua_ls",

		-- Python
		"pyright",

		-- Rust
		"rust_analyzer",

		-- JavaScript, TypeScript
		"typescript-language-server",
		"eslint",

		-- Shell
		"bashls",
		"shellcheck",

		-- json
		"jsonls",

		-- yaml
		"yamlls",

		-- dockerls
		"dockerls",

		-- web
		"angularls",

		-- Ansible
		"ansiblels",
	},
	formatters = {
		-- Lua
		"stylua",

		-- Python
		"black",
		"isort",

		-- Rust
		"rustfmt",

		-- JavaScript, TypeScript
		"prettierd",
		"prettier",

		-- Shell
		"shfmt",

    -- XML
    "xmlformatter"
	},
	linters = {
		-- Shell
		"shellcheck",
	},
}

-- Lazy loading of plugins
require("lazy").setup({
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

	-- TODO [FIXME]: package produce error
	-- {
	-- 	"rmagatti/auto-session",
	-- },

	{
		"rmagatti/session-lens",
		-- requires = {
		-- 	"rmagatti/auto-session",
		-- 	"nvim-telescope/telescope.nvim", -- NOTE: needed but mentioned above
		-- },
		dependencies = {
			{
				"rmagatti/auto-session",
				config = function()
					require("auto-session").setup({
						log_level = "error",
						auto_session_enabled = true,
						-- BUG: (produce error): auto_session_enable_last_session = true,
						auto_session_last_session_dir = vim.fn.stdpath("data") .. "/sessions/",
						auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
						auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
						-- -- table: Config for handling the DirChangePre and DirChanged autocmds, can be set to nil to disable altogether
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
		},

		opts = {
			-- width
		},
		-- config = function()
		-- 	require("session-lens").setup({})
		--   end,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			filesystem_watchers = {
				enable = true,
			},
			git = {
				enable = false, -- This insure that nvim-tree resheshes all, even if the files are ignored by .gitignore
			},
		},
		config = function(_, opts)
			require("nvim-tree").setup(opts)
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				options = {
					theme = "palenight",
				},
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

	{
		"zbirenbaum/copilot-cmp",
		opts = {
			sources = {
				-- Copilot Source
				{ name = "copilot", group_index = 2 },
				-- Other Sources
				{ name = "nvim_lsp", group_index = 2 },
				{ name = "path", group_index = 2 },
				{ name = "luasnip", group_index = 2 },
			},
		},
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
				dependencies = {
					"junegunn/fzf",
				},
				config = function()
					require("telescope").load_extension("fzf")
					require("telescope").load_extension("session-lens")
				end,
			},

			{
				"smartpde/telescope-recent-files",
			},

			{
				"nvim-telescope/telescope-file-browser.nvim",
			},

			{
				"LukasPietzschmann/telescope-tabs",
				config = function()
					local telescope = require("telescope")
					telescope.load_extension("telescope-tabs")
					require("telescope-tabs").setup()
				end,
				dependencies = { "nvim-telescope/telescope.nvim" },
			},
		},
		opts = {
			defaults = {
				layout_strategy = "vertical",
				-- layout_strategy = "flex",
				-- layout_strategy = "horizontal",
				layout_config = {
					vertical = {
						width = 0.9,
						height = 0.9,
					},
					horizontal = {
						width = 0.9,
						height = 0.9,
					},
				},
			},
			pickers = {
				find_files = {
					theme = "dropdown",
				},
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
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)

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
			vim.keymap.set("n", "<leader>tgs", builtin.grep_string, { desc = "Telescope grep string" })
			vim.keymap.set("n", "<leader>tts", builtin.treesitter, { desc = "Telescope treesitter" })
			vim.keymap.set("n", "<leader>tdd", builtin.diagnostics, { desc = "Telescope diagnostics" })
			vim.keymap.set("n", "<leader>tjj", builtin.jumplist, { desc = "Telescope jumplist" })
			vim.keymap.set("n", "<leader>ttt", ":Telescope telescope-tabs list_tabs<CR>", {
				noremap = true,
				silent = true,
				desc = "Telescope telescope-tabs list_tabs",
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"jsonc",
					"yaml",
					"javascript",
					"typescript",
					"html",
					"css",
					"lua",
					"python",
					"rust",
					"bash",
					"dockerfile",
					"go",
					"graphql",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	{
		"nvimdev/hlsearch.nvim",
		event = "BufRead",
		opts = {},
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},

	{ -- Automatically install LSPs to stdpath for neovim
		"williamboman/mason.nvim",
		depenedencies = {
			-- LSP

			-- Formaters
		},
		opts = {},
		config = function(_, opts)
			require("mason").setup(opts)
		end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				unpack(MASON.formatters),
				unpack(MASON.lsp),
				unpack(MASON.linters),
			},
			run_on_start = true,
			integrations = {
				["mason-lspconfig"] = true,
			},
		},
		config = function(_, opts)
			require("mason-tool-installer").setup(opts)
			-- print opts to cli
			-- print(vim.inspect(opts))
		end,
	},

	{
		"jamestthompson3/nvim-remote-containers",
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
		end,
	},

	{
		"nvim/nvim-lspconfig",
		config = function(_, _)
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					virtual_text = false,
					update_in_insert = false,
				})

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
				vim.keymap.set(
					"n",
					"<leader>lbdf",
					"<cmd>lua vim.lsp.buf.definition()<CR>",
					{ noremap = true, silent = true, desc = "Goto Definition" }
				)
				vim.keymap.set(
					"n",
					"<leader>lbdc",
					"<cmd>lua vim.lsp.buf.declaration()<CR>",
					{ noremap = true, silent = true, desc = "Goto Declaration" }
				)
				vim.keymap.set(
					"n",
					"<leader>lbrf",
					"<cmd>lua vim.lsp.buf.references()<CR>",
					{ noremap = true, silent = true, desc = "Goto References" }
				)
				vim.keymap.set(
					"n",
					"<leader>lbrn",
					"<cmd>lua vim.lsp.buf.rename()<CR>",
					{ noremap = true, silent = true, desc = "Rename" }
				)
				vim.keymap.set(
					"n",
					"<leader>lbhh",
					"<cmd>lua vim.lsp.buf.hover()<CR>",
					{ noremap = true, silent = true, desc = "Hover" }
				)
				vim.keymap.set(
					"n",
					"<leader>lbca",
					"<cmd>lua vim.lsp.buf.code_action()<CR>",
					{ noremap = true, silent = true, desc = "Code Action" }
				)
				vim.keymap.set(
					"n",
					"<leader>lbsh",
					"<cmd>lua vim.lsp.buf.signature_help()<CR>",
					{ noremap = true, silent = true, desc = "Signature Help" }
				)
				vim.keymap.set(
					"n",
					"<leader>lbtd",
					"<cmd>lua vim.lsp.buf.type_definition()<CR>",
					{ noremap = true, silent = true, desc = "Type Definition" }
				)
			end

			lspconfig["angularls"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				root_dir = lspconfig.util.root_pattern("angular.json"),
			})
			lspconfig["ansiblels"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				root_dir = lspconfig.util.root_pattern("ansible.cfg"),
			})
			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
		config = function(_, opts)
			local conform = require("conform")
			conform.setup(opts)
			vim.keymap.set("n", "<leader>cf", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format" })
		end,
	},

	{
		"zapling/mason-conform.nvim",
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
			-- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.keymap.set("n", "<leader>cl", function()
				lint.try_lint()
			end, { desc = "Lint" })
			-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
			-- 	group = lint_augroup,
			-- 	callback = function()
			-- 		lint.try_lint()
			-- 	end,
			-- })
		end,
	},

	{
		"folke/neodev.nvim",
		opts = {},
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
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					-- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- NOTE: select = false, ensure that the first completion is not auto selected
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "cmdline" },
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
		end,
	},

	{
		"tpope/vim-fugitive",
	},

	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics focus<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	{
		-- Quickfix
		"kevinhwang91/nvim-bqf",
		ft = "qf",
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},

	{
		"nvim-pack/nvim-spectre",
	},

	{
		"dyng/ctrlsf.vim",
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"gennaro-tedesco/nvim-possession",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
		config = true,
		init = function()
			local possession = require("nvim-possession")
			vim.keymap.set("n", "<leader>sl", function()
				possession.list()
			end, { desc = "List sessions" })
			vim.keymap.set("n", "<leader>sn", function()
				possession.new()
			end, { desc = "New session" })
			vim.keymap.set("n", "<leader>su", function()
				possession.update()
			end, { desc = "Update session" })
			vim.keymap.set("n", "<leader>sd", function()
				possession.delete()
			end, { desc = "Delete session" })
		end,
	},
}, {})

local function setup_colorscheme()
	-- All file types tokyonight
	vim.api.nvim_command("autocmd BufEnter * colorscheme tokyonight-moon")
	-- yaml or yml set tokyonight-moon
	vim.api.nvim_command("autocmd BufEnter *.yaml,*.yml colorscheme tokyonight-moon")
end
setup_colorscheme()

-- vim.g.loaded_netrw = 1 -- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrwPlugin = 1
--
-- require("mason").setup({ log_level = vim.log.lev })
-- require("mason").setup({ log_level = vim.log.levels.DEBUG })
-- -- local ensure_installed_packages = {
-- -- "pyright",
-- -- "tsserver",
-- -- "lua_ls",
-- -- "lua",
-- -- "jsonls",
-- -- "yamlls",
-- -- "bashls",
-- -- "dockerls",
-- -- "gopls",
-- -- "html",
-- -- "cssls",
-- -- "vimls",
-- -- "clangd",
-- -- "rust_analyzer",
-- -- "jdtls",
-- -- "terraformls",
-- -- "svelte",
-- -- "tailwindcss",
-- -- "graphql",
-- -- "phpactor",
-- -- "intelephense",
-- -- "angularls",
-- -- "denols",
-- -- "solargraph",
-- -- "sqlls",
-- -- "stylelint_lsp",
-- -- "vuels",
-- -- "zls",
-- -- "hls",
-- -- }

-- Vim Configuration
vim.cmd("autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab")
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set notimeout nottimeout")
vim.cmd("set clipboard+=unnamedplus") -- ensure yanking to system clipboard
vim.cmd("command! RemoveQFItem lua RemoveQFItem()") -- Create a command to call the function

vim.wo.relativenumber = true
vim.wo.number = true
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

-- Copy/Yank to clipboard based on OS
if vim.fn.has("macunix") == 1 then
	vim.opt.clipboard = "unnamed"
else
	vim.opt.clipboard = "unnamedplus"
end

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
-- Define the function to remove the quickfix item
RemoveQFItem = function() -- luacheck: ignore
	local curqfidx = vim.fn.line(".") - 1
	local qfall = vim.fn.getqflist()
	table.remove(qfall, curqfidx + 1)
	vim.fn.setqflist(qfall, "r")
	vim.cmd(tostring(curqfidx + 1) .. "cfirst")
	vim.cmd("copen")
end

-- Use `map <buffer>` to only map `dd` in the quickfix window
vim.cmd([[
    augroup RemoveQFMapping
        autocmd!
        autocmd FileType qf nnoremap <buffer> dd :RemoveQFItem<CR>
    augroup END
]])

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.cmd("set foldmethod=indent") -- set Folding
vim.cmd("set foldlevel=99") -- auto unfold all folds on opening a file

-- vim.api.nvim_command("colorscheme tokyonight-moon")

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

-- Horizontal split resize
vim.keymap.set("n", "<leader>+", [[<C-w>+]], { desc = "Increase horizontal split size" })
vim.keymap.set("n", "<leader>-", [[<C-w>-]], { desc = "Decrease horizontal split size" })
