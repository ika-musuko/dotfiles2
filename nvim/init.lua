-- plugins
require("paq")({
	"savq/paq-nvim",

	"bullets-vim/bullets.vim",

	"leafOfTree/vim-matchtag",
	"justinmk/vim-matchparenalways",

	"tpope/vim-surround",
	"tpope/vim-repeat",
	"tpope/vim-abolish",
	"tpope/vim-sleuth",

	"LunarVim/bigfile.nvim",

	"szw/vim-maximizer",
	"shortcuts/no-neck-pain.nvim",
	"ten3roberts/window-picker.nvim",

	"nvim-lua/plenary.nvim", -- needed for telescope
	"nvim-telescope/telescope-fzf-native.nvim",
	"nvim-telescope/telescope.nvim",

	"folke/trouble.nvim",
	"nvim-tree/nvim-web-devicons",

	"numirias/semshi",

	"dgagn/diagflow.nvim",
})

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

-- languages and formatting
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
	command = "setlocal tabstop=2 softtabstop=2 shiftwidth=2 tabstop=2 expandtab",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "setIndent",
	pattern = {
		"lua",
	},
	command = "setlocal tabstop=4 softtabstop=4 shiftwidth=4 tabstop=4 noexpandtab",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "setIndent",
	pattern = {
		"go",
	},
	command = "setlocal tabstop=8 softtabstop=8 shiftwidth=8 tabstop=8 noexpandtab",
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
	command = "setlocal tabstop=4 softtabstop=4 shiftwidth=4 tabstop=4 expandtab",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.jinja", "*.jinja2" },
	callback = function()
		vim.bo.filetype = "html"
	end,
})

-- cursor settings
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- color scheme
vim.o.termguicolors = false
vim.opt.background = "dark"
vim.cmd("colorscheme default")
vim.cmd("set t_Co=8")

vim.cmd("syntax clear")
vim.cmd("syntax on")

local function apply_semshi()
	-- see https://github.com/numirias/semshi?tab=readme-ov-file#highlights
	vim.cmd("highlight semshiGlobal     ctermfg=NONE")
	vim.cmd("highlight semshiImported   ctermfg=NONE")
	vim.cmd("highlight semshiBuiltin    ctermfg=NONE")
	vim.cmd("highlight semshiAttribute  ctermfg=NONE")
	vim.cmd("highlight semshiFree       ctermfg=magenta")
	vim.cmd("highlight semshiSelected   ctermfg=black ctermbg=blue")
	vim.cmd("highlight semshiParameter  ctermfg=cyan")
end

vim.api.nvim_create_autocmd({ "FileType" }, { pattern = { "python" }, callback = apply_semshi })
vim.api.nvim_create_autocmd({ "ColorScheme" }, { pattern = { "*" }, callback = apply_semshi })

vim.cmd("highlight Function ctermfg=NONE")
vim.cmd("highlight Class ctermfg=NONE")
vim.cmd("highlight Identifier ctermfg=NONE")
vim.cmd("highlight Statement ctermfg=NONE")
vim.cmd("highlight Special ctermfg=NONE")

vim.cmd("highlight Cursor  ctermbg=0")
vim.cmd("highlight Comment ctermfg=15")
vim.cmd("highlight Todo    ctermfg=black ctermbg=red")
vim.cmd("highlight String guifg=green ctermfg=green")
vim.cmd("highlight Comment ctermfg=15 guifg=white")
vim.cmd("highlight Whitespace ctermfg=8")

vim.cmd("highlight MatchParen cterm=NONE ctermbg=15 ctermfg=black")
vim.cmd("highlight MatchPairs cterm=NONE ctermbg=15 ctermfg=black")
vim.cmd("highlight matchTag   cterm=NONE ctermbg=15 ctermfg=black")

vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")
vim.cmd("highlight LineNr ctermfg=8 ctermbg=NONE guibg=NONE")

-- environment settings
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

vim.keymap.set("n", "g<Return>", ":noh<CR>")

-- commands
-- uppercase corrections
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Sp", "sp", {})
vim.api.nvim_create_user_command("Vsp", "vsp", {})

-- trim whitespace at end of lines
local function trim_whitespace()
	local save = vim.fn.winsaveview()
	vim.api.nvim_exec("%s/\\s\\+$//e", false)
	vim.fn.winrestview(save)
end

vim.api.nvim_create_user_command("TrimWhitespace", trim_whitespace, {})
vim.keymap.set("", "<leader>s", ":TrimWhitespace<CR>")

-- rename file
vim.api.nvim_create_user_command("Rn", function(opts)
	local old_name = vim.fn.expand("%")
	local new_name = opts.fargs[1]
	vim.api.nvim_exec2("f " .. new_name, {})
	vim.api.nvim_exec2("w", {})
	vim.api.nvim_exec2("!rm " .. old_name, {})
end, { nargs = 1 })

-- terminal
vim.keymap.set("", "<leader>e", ":Term<CR>")

-- center window
require("no-neck-pain").setup({
	width = 150,
})
vim.keymap.set("", "<leader>g", ":NoNeckPain<CR>")

-- maximizer
vim.keymap.set("", "<leader>z", ":MaximizerToggle<CR>")

-- config keybindings
-- neovim configs
local init_file = "~/.config/nvim/init.lua"
local refresh_cmd = ":so " .. init_file .. "<CR>"
vim.keymap.set("n", "<leader>,e", ":e " .. init_file .. "<CR>")
vim.keymap.set("n", "<leader>,r", refresh_cmd)
vim.keymap.set("n", "<leader>,p", refresh_cmd .. ":PaqSync<CR>")

-- other configs
local conf_files = {
	kitty = "~/.config/kitty/kitty.conf",
	tmux = "~/.tmux.conf",
	vim = "~/.config/nvim/init.lua",
	zsh = "~/.zshrc",
}

local function open_conf(conf)
	return function()
		vim.api.nvim_command("e " .. conf)
	end
end

for name, file in pairs(conf_files) do
	vim.api.nvim_create_user_command("Cf" .. name, open_conf(file), {})
end

-- buffer keybindings
vim.keymap.set("", "<C-\\>", "<C-^>") -- navigate to MRU buffer
vim.keymap.set("", "<leader><BS>", ":bp | vsp | bn | bd!<CR>") -- delete current buffer

vim.keymap.set("", "<leader>t", ":Trouble diagnostics toggle<CR>")

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

-- misc commands
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
