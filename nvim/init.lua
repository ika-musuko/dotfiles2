--- plugins
vim.cmd("packadd packer.nvim")

require("packer").startup(function(use)
	use("bullets-vim/bullets.vim")

	use("leafOfTree/vim-matchtag")
	use("justinmk/vim-matchparenalways")

	use("tpope/vim-surround")
	use("tpope/vim-repeat")

	use("tpope/vim-abolish") -- case insensitive replace (:%S)

	use("LunarVim/bigfile.nvim")

	use("szw/vim-maximizer")
	use("shortcuts/no-neck-pain.nvim")
	use("ten3roberts/window-picker.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
	})

	use("folke/trouble.nvim")
	use("nvim-tree/nvim-web-devicons")

	use("leafOfTree/vim-svelte-plugin",)

	use("dgagn/diagflow.nvim")
end)

--- languages and formatting (MUST BE NEAR TOP)
local function set_indent(opts)
	vim.opt_local.tabstop = opts.width
	vim.opt_local.softtabstop = opts.width
	vim.opt_local.shiftwidth = opts.width
	vim.opt_local.expandtab = not opts.use_tabs or true
end

vim.api.nvim_create_augroup("setIndent", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "setIndent",
	pattern = {
		"css",
		"html",
		"javascript",
		"typescript",
		"scss",
		"xml",
		"xhtml",
		"yaml",
		"jinja",
		"svelte",
		"markdown",
		"md",
	},
	callback = function()
		set_indent({ width = 2 })
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "setIndent",
	pattern = {
		"lua",
	},
	callback = function()
		set_indent({ width = 4, use_tabs = true })
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "setIndent",
	pattern = {
		"go",
	},
	callback = function()
		set_indent({ width = 8, use_tabs = true })
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "setIndent",
	pattern = {
		"python",
		"cpp",
		"c",
		"java",
		"groovy",
		"json",
	},
	callback = function()
		set_indent({ width = 4 })
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.jinja", "*.jinja2" },
	callback = function()
		vim.bo.filetype = "html"
	end,
})

vim.g.vim_svelte_plugin_load_full_syntax = 1

--- color scheme
vim.o.termguicolors = false
vim.opt.background = "dark"
vim.cmd("colorscheme default")
vim.cmd("set t_Co=8")

vim.cmd("syntax clear")
vim.cmd("syntax on")

-- interface
vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")
vim.cmd("highlight LineNr ctermfg=8 ctermbg=NONE guibg=NONE")
vim.cmd("highlight CursorLine ctermbg=black")

-- force no highlight
vim.cmd("highlight Function ctermfg=NONE")
vim.cmd("highlight Class ctermfg=NONE")
vim.cmd("highlight Identifier ctermfg=NONE")
vim.cmd("highlight Statement ctermfg=NONE")

-- highlights
vim.cmd("highlight Cursor     ctermbg=0")
vim.cmd("highlight Comment    ctermfg=15")
vim.cmd("highlight Todo       ctermfg=red ctermbg=black")
vim.cmd("highlight String     ctermfg=green")
vim.cmd("highlight Comment    ctermfg=15")
vim.cmd("highlight Whitespace ctermfg=8")
vim.cmd("highlight Special    ctermfg=yellow")

vim.cmd("highlight htmlTag     ctermfg=14")
vim.cmd("highlight htmlTagN    ctermfg=14")
vim.cmd("highlight htmlTagName ctermfg=14")
vim.cmd("highlight htmlArg     ctermfg=14")
vim.cmd("highlight htmlEndTag  ctermfg=14")

vim.cmd("highlight markdownH1  ctermfg=14")
vim.cmd("highlight markdownH2  ctermfg=10")
vim.cmd("highlight markdownH3  ctermfg=6")
vim.cmd("highlight markdownH4  ctermfg=2")
vim.cmd("highlight markdownH1Delimiter ctermfg=14")
vim.cmd("highlight markdownH2Delimiter ctermfg=10")
vim.cmd("highlight markdownH3Delimiter ctermfg=6")
vim.cmd("highlight markdownH4Delimiter ctermfg=2")
vim.cmd("highlight markdownListMarker        ctermfg=NONE")
vim.cmd("highlight markdownOrderedListMarker ctermfg=NONE")

vim.cmd("highlight MatchParen cterm=NONE ctermbg=black ctermfg=magenta")
vim.cmd("highlight MatchPairs cterm=NONE ctermbg=black ctermfg=magenta")
vim.cmd("highlight matchTag   cterm=NONE ctermbg=black ctermfg=magenta")

--- environment settings
vim.cmd("autocmd FocusGained * checktime")

vim.opt.list = true
vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.showcmd = true
vim.opt.hlsearch = true

vim.opt.undodir = vim.fn.expand("~/.vimdid/")
vim.opt.undofile = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"

--- native keybindings
-- config keybindings
local init_file = "~/.config/nvim/init.lua"
local refresh_cmd = ":so " .. init_file .. "<CR>"
vim.keymap.set("n", "<leader>,e", ":e " .. init_file .. "<CR>")
vim.keymap.set("n", "<leader>,r", refresh_cmd)
vim.keymap.set("n", "<leader>,p", refresh_cmd .. ":PackerSync<CR>")

-- window navigation
vim.keymap.set("", "<C-h>", "<C-w>h")
vim.keymap.set("", "<C-j>", "<C-w>j")
vim.keymap.set("", "<C-k>", "<C-w>k")
vim.keymap.set("", "<C-l>", "<C-w>l")

vim.keymap.set("i", "<C-h>", "<Esc><C-w>h")
vim.keymap.set("i", "<C-j>", "<Esc><C-w>j")
vim.keymap.set("i", "<C-k>", "<Esc><C-w>k")
vim.keymap.set("i", "<C-l>", "<Esc><C-w>l")

-- horizontal scroll
vim.keymap.set("", "<S-ScrollWheelUp>", "4zh")
vim.keymap.set("", "<S-ScrollWheelDown>", "4zl")
vim.keymap.set("", "<S-Left>", "8zh")
vim.keymap.set("", "<S-Right>", "8zl")

-- terminal normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- disable highlight
vim.keymap.set("n", "g<Return>", ":noh<CR>")

--- plugin settings and keybindings
-- telescope
require("telescope").setup({
	defaults = {
		preview = false,
		layout_config = {
			horizontal = {
				height = 0.8,
			},
			vertical = {
				height = 0.8,
			},
		},
	},
	pickers = {
		find_files = {
			disable_devicons = false,
		},
	},
})

local function file_opener()
	return require("telescope.builtin").find_files({ hidden = true })
end

local function file_opener_ignore_vcs()
	return require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
end

local function buffer_opener()
	return require("telescope.builtin").buffers()
end

local function live_grep()
	return require("telescope.builtin").live_grep()
end

vim.keymap.set("", "<leader>p", file_opener)
vim.keymap.set("", "<leader>P", file_opener_ignore_vcs)
vim.keymap.set("", "<leader>b", buffer_opener)
vim.keymap.set("", "<leader>f", live_grep)

-- window-picker
require("window-picker").setup({
	keys = "asdfvrcexwzqgbthnyjmukilop",
	swap_shift = true,
	exclude = { qf = true, NvimTree = true, aerial = true },
	hide_other_statuslines = false,
})
vim.api.nvim_set_keymap("n", "<leader>w", ":WindowPick<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>W", ":WindowSwap<CR>", {})

-- center window
require("no-neck-pain").setup({
	width = 150,
})

local function toggle_window_centering()
	require("no-neck-pain").toggle()
end

local function toggle_presentation_mode()
	toggle_window_centering()
	require("no-neck-pain").resize(50)
end

vim.keymap.set("", "<leader>g", toggle_window_centering)
vim.keymap.set("", "<leader>G", toggle_presentation_mode)

-- maximizer
vim.keymap.set("", "<leader>z", ":MaximizerToggle<CR>")

--- custom commands and keybindings
-- uppercase corrections
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Sp", "sp", {})
vim.api.nvim_create_user_command("Vsp", "vsp", {})

-- cursor centering for easier prose writing
vim.g.force_cursor_center = false

local function toggle_cursor_center()
	vim.g.force_cursor_center = not vim.g.force_cursor_center
	if vim.g.force_cursor_center then
		print("Cursor centering enabled")
	else
		print("Cursor centering disabled")
	end
end

vim.api.nvim_create_autocmd({ "CursorMoved", "InsertLeave" }, {
	pattern = "*",
	callback = function()
		if vim.g.force_cursor_center then
			vim.api.nvim_command("normal! zz")
		end
	end,
})

vim.api.nvim_create_user_command("ToggleCenter", toggle_cursor_center, {})
vim.keymap.set("", "<leader>c", ":ToggleCenter<CR>")

-- set filetype shortcut
vim.api.nvim_create_user_command("F", function(opts)
	vim.bo.filetype = opts.fargs[1]
end, { nargs = 1 })

-- trim whitespace at end of lines
local function trim_whitespace()
	local current_view = vim.fn.winsaveview()
	vim.api.nvim_exec("%s/\\s\\+$//e", false)
	vim.fn.winrestview(current_view)
end

vim.api.nvim_create_user_command("TrimWhitespace", trim_whitespace, {})
vim.keymap.set("", "<leader>s", ":TrimWhitespace<CR>")

-- rename file
local function copy_file(new_name)
	vim.api.nvim_exec2("f " .. new_name, {})
	vim.api.nvim_exec2("w", {})
end

vim.api.nvim_create_user_command("Cp", function(opts)
	local new_name = opts.fargs[1]
	copy_file(new_name)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Rn", function(opts)
	local old_name = vim.fn.expand("%")
	local new_name = opts.fargs[1]
	copy_file(new_name)
	vim.api.nvim_exec2("!rm " .. old_name, {})
end, { nargs = 1 })
