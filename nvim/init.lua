--- PLUGINS
vim.cmd("packadd packer.nvim")

require("packer").startup(function(use)
	use("wbthomason/packer.nvim") -- packer itself

	use("bullets-vim/bullets.vim")

	use("leafOfTree/vim-matchtag")
	use("justinmk/vim-matchparenalways")

	use("ika-musuko/vim-surround")
	use("tpope/vim-repeat")
	use("tpope/vim-scriptease")

	use("tpope/vim-abolish") -- case insensitive replace (:%S)

	--use("tpope/vim-sleuth") -- try to respect current project's indent settings

	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")

	use("michaeljsmith/vim-indent-object")

	use("LunarVim/bigfile.nvim")

	use("szw/vim-maximizer")
	use("shortcuts/no-neck-pain.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
	})

	use("MagicDuck/grug-far.nvim")

	use("j-morano/buffer_manager.nvim")

	use("nvim-tree/nvim-web-devicons")

	use("Shougo/context_filetype.vim") -- single file multiple lang support
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	use("leafOfTree/vim-svelte-plugin")
	use("leafOfTree/vim-vue-plugin")
	use("terrastruct/d2-vim")

	use("zorab47/procfile.vim")
end)

--- language indenting (MUST BE NEAR TOP)
local function set_indent(opts)
	vim.opt_local.tabstop = opts.width
	vim.opt_local.softtabstop = opts.width
	vim.opt_local.shiftwidth = opts.width
	vim.opt_local.expandtab = not opts.use_tabs
end

vim.api.nvim_create_augroup("setIndent", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "setIndent",
	pattern = {
		"css",
		"html",
		"javascript",
		"jsx",
		"typescript",
		"typescriptreact",
		"tsx",
		"scss",
		"xml",
		"xhtml",
		"yaml",
		"jinja",
		"md",
		"d2",
	},
	callback = function()
		set_indent({ width = 2 })
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "setIndent",
	pattern = {
		"svelte",
	},
	callback = function()
		set_indent({ width = 2, use_tabs = true })
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
		"cpp",
		"c",
		"java",
		"groovy",
		"json",
		"cucumber",
		"markdown",
	},
	callback = function()
		set_indent({ width = 4 })
	end,
})


vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "setIndent",
	pattern = {
		"python",
	},
	callback = function()
		set_indent({ width = 4 })
	end,
})



-- language highlighting
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	incremental_selection = { enable = true },
	textobjects = { enable = true },
	indent = { enable = true },
	ensure_installed = {
		"cpp",
	},
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
	pattern = {"*.jinja", "*.jinja2"},
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

do
	-- color names
	local black = 0
	local red = 1
	local green = 2
	local yellow = 3
	local blue = 4
	local magenta = 5
	local cyan = 6
	local white = 7
	local brightblack = 8
	local brightred = 9
	local brightgreen = 10
	local brightyellow = 11
	local brightblue = 12
	local brightmagenta = 13
	local brightcyan = 14
	local brightwhite = 15

	local none = "NONE"

	-- color helpers
	local default = none

	-- default text color
	vim.api.nvim_set_hl(0, "Normal", { ctermfg = default, ctermbg = none })

	-- interface
	vim.api.nvim_set_hl(0, "Visual", { ctermfg = none, ctermbg = "darkgray" })

	vim.api.nvim_set_hl(0, "StatusLine", { ctermfg = white, ctermbg = brightblack })
	vim.api.nvim_set_hl(0, "StatusLineNC", { ctermfg = brightblack, ctermbg = black })

	vim.api.nvim_set_hl(0, "Search", { ctermfg = black, ctermbg = yellow })
	vim.api.nvim_set_hl(0, "CurSearch", { ctermfg = black, ctermbg = green })

	vim.api.nvim_set_hl(0, "LineNr", { ctermfg = brightblack, ctermbg = none })
	vim.api.nvim_set_hl(0, "CursorLineNr", { ctermfg = brightwhite, ctermbg = none })

	-- syntax highlights
	vim.api.nvim_set_hl(0, "Function", { ctermfg = default })
	vim.api.nvim_set_hl(0, "Class", { ctermfg = cyan })
	vim.api.nvim_set_hl(0, "Type", { ctermfg = cyan })
	vim.api.nvim_set_hl(0, "Identifier", { ctermfg = default })
	vim.api.nvim_set_hl(0, "Statement", { ctermfg = green })
	vim.api.nvim_set_hl(0, "Constant", { ctermfg = blue })
	vim.api.nvim_set_hl(0, "Comment", { ctermfg = brightwhite })
	vim.api.nvim_set_hl(0, "String", { ctermfg = brightmagenta })
	vim.api.nvim_set_hl(0, "Whitespace", { ctermfg = 8 })
	vim.api.nvim_set_hl(0, "Special", { ctermfg = yellow })
	vim.api.nvim_set_hl(0, "PreProc", { ctermfg = green })
	vim.api.nvim_set_hl(0, "Todo", { ctermbg = red, ctermfg = black })

	-- match
	local match_fg = "gray"
	vim.api.nvim_set_hl(0, "MatchParen", { ctermfg = match_fg })
	vim.api.nvim_set_hl(0, "MatchPairs", { ctermfg = match_fg })
	vim.api.nvim_set_hl(0, "matchTag", { ctermfg = match_fg })

	-- tmux
	vim.cmd("hi link tmuxVariableExpansion Special")
	vim.cmd("hi link tmuxFormatString Special")

	-- lua
	vim.cmd("hi link @function.builtin.lua Normal")
	vim.cmd("hi link @constructor.lua Normal")

	-- html
	local html_tag_color = brightblue
	vim.api.nvim_set_hl(0, "htmlTag", { ctermfg = brightgreen })
	vim.api.nvim_set_hl(0, "htmlTagN", { ctermfg = html_tag_color })
	vim.api.nvim_set_hl(0, "htmlTagName", { ctermfg = html_tag_color })
	vim.api.nvim_set_hl(0, "htmlArg", { ctermfg = brightyellow })
	vim.api.nvim_set_hl(0, "htmlEndTag", { ctermfg = brightred })
	vim.api.nvim_set_hl(0, "jinjaString", { ctermfg = cyan })

	vim.api.nvim_set_hl(0, "cssTagName", { ctermfg = html_tag_color })
	vim.cmd("hi link cssVendor Normal")
	vim.cmd("hi link cssAttrComma Normal")
	vim.cmd("hi link cssSelectorOp Normal")
	vim.cmd("hi link cssSelectorOp2 Normal")
	vim.cmd("hi link cssAttributeSelector Normal")
	vim.cmd("hi link cssPseudoClassId Normal")
	vim.cmd("hi link cssAtRule Normal")
	vim.cmd("hi link cssCustomProp Normal")

	vim.cmd("hi link javaScript Normal")
	vim.api.nvim_set_hl(0, "@function.call.javascript", { ctermfg = brightblue })
	vim.api.nvim_set_hl(0, "@variable.member.javascript", { ctermfg = brightblue })
	vim.cmd("hi link javaScriptEmbed Normal")
	vim.cmd("hi link javaScriptBraces Normal")
	vim.cmd("hi link javaScriptMember Normal")
	vim.cmd("hi link javaScriptIdentifier Statement")
	vim.cmd("hi link javaScriptModifier Statement")

	-- vue
	local vue_color = brightcyan
	vim.api.nvim_set_hl(0, "vueTag", { ctermfg = vue_color })
	vim.api.nvim_set_hl(0, "VueQuote", { ctermfg = vue_color })
	vim.api.nvim_set_hl(0, "VueAttr", { ctermfg = vue_color })
	vim.api.nvim_set_hl(0, "VueKey", { ctermfg = vue_color })
	vim.api.nvim_set_hl(0, "VueValue", { ctermfg = vue_color })

	vim.cmd("hi link VueExpression PreProc")
	vim.cmd("hi link VueBrace PreProc")

	-- python
	vim.cmd("hi link pythonDecorator Special")
	vim.cmd("hi link pythonDecoratorName Special")
	vim.cmd("hi link pythonBuiltin Normal")

	-- c/c++
	vim.cmd("hi link cCharacter Special")
	vim.cmd("hi link cParen MatchParen")

	-- d2
	vim.cmd("hi link d2Operator Special")

	-- markdown
	local h1 = cyan
	local h2 = blue
	local h3 = brightcyan
	local h4 = brightblue
	vim.api.nvim_set_hl(0, "markdownH1", { ctermfg = h1 })
	vim.api.nvim_set_hl(0, "markdownH2", { ctermfg = h2 })
	vim.api.nvim_set_hl(0, "markdownH3", { ctermfg = h3 })
	vim.api.nvim_set_hl(0, "markdownH4", { ctermfg = h4 })
	vim.api.nvim_set_hl(0, "markdownH1Delimiter", { ctermfg = h1 })
	vim.api.nvim_set_hl(0, "markdownH2Delimiter", { ctermfg = h2 })
	vim.api.nvim_set_hl(0, "markdownH3Delimiter", { ctermfg = h3 })
	vim.api.nvim_set_hl(0, "markdownH4Delimiter", { ctermfg = h4 })
	vim.api.nvim_set_hl(0, "markdownListMarker", { ctermfg = default })
	vim.api.nvim_set_hl(0, "markdownOrderedListMarker", { ctermfg = default })
	vim.api.nvim_set_hl(0, "markdownCode", { ctermfg = brightyellow })
	vim.api.nvim_set_hl(0, "markdownCodeBlock", { ctermfg = brightyellow })
	vim.api.nvim_set_hl(0, "markdownUrl", { ctermfg = brightmagenta })

	-- yaml
	vim.cmd("hi link yamlBlockMappingKey Constant")
end

--- environment settings
vim.cmd("autocmd FocusGained * checktime")

vim.opt.list = true
vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = "%s %l %r"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.showcmd = true
vim.opt.hlsearch = true

vim.opt.undodir = vim.fn.expand("~/.vimdid/")
vim.opt.undofile = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

--- native keybindings
-- config keybindings and commands
do
	local init_file = "~/.config/nvim/init.lua"

	local function reload_config()
		vim.cmd.source(init_file)
	end

	vim.keymap.set("n", "<M-/>", reload_config)
end
--
-- terminal normal mode
local TERM_ESCAPE = "<C-\\><C-n>"
vim.keymap.set("t", "<M-Esc>", TERM_ESCAPE)

-- window navigation and management
vim.keymap.set("", "<C-h>", "<C-w>h")
vim.keymap.set("", "<C-j>", "<C-w>j")
vim.keymap.set("", "<C-k>", "<C-w>k")
vim.keymap.set("", "<C-l>", "<C-w>l")
vim.keymap.set("", "<M-h>", "<C-w>h")
vim.keymap.set("", "<M-j>", "<C-w>j")
vim.keymap.set("", "<M-k>", "<C-w>k")
vim.keymap.set("", "<M-l>", "<C-w>l")
vim.keymap.set("i", "<C-h>", "<Esc><C-w>h")
vim.keymap.set("i", "<C-j>", "<Esc><C-w>j")
vim.keymap.set("i", "<C-k>", "<Esc><C-w>k")
vim.keymap.set("i", "<C-l>", "<Esc><C-w>l")
vim.keymap.set("i", "<M-h>", "<Esc><C-w>h")
vim.keymap.set("i", "<M-j>", "<Esc><C-w>j")
vim.keymap.set("i", "<M-k>", "<Esc><C-w>k")
vim.keymap.set("i", "<M-l>", "<Esc><C-w>l")
vim.keymap.set("t", "<C-h>", TERM_ESCAPE .. "<C-w>h")
vim.keymap.set("t", "<C-j>", TERM_ESCAPE .. "<C-w>j")
vim.keymap.set("t", "<C-k>", TERM_ESCAPE .. "<C-w>k")
vim.keymap.set("t", "<C-l>", TERM_ESCAPE .. "<C-w>l")
vim.keymap.set("t", "<M-h>", TERM_ESCAPE .. "<C-w>h")
vim.keymap.set("t", "<M-j>", TERM_ESCAPE .. "<C-w>j")
vim.keymap.set("t", "<M-k>", TERM_ESCAPE .. "<C-w>k")
vim.keymap.set("t", "<M-l>", TERM_ESCAPE .. "<C-w>l")

vim.keymap.set("n", "<M-f>", "<C-w><C-w>")
vim.keymap.set("n", "<M-g>", "<C-6>")
vim.keymap.set("t", "<M-f>", TERM_ESCAPE .. "<C-w><C-w>")
vim.keymap.set("t", "<M-g>", TERM_ESCAPE .. "<C-6>")

vim.keymap.set("n", "<M-v>", ":sp<Return>")
vim.keymap.set("n", "<M-b>", ":vsp<Return>")
vim.keymap.set("n", "<M-t>", ":term<Return>")

vim.keymap.set("n", "<M-q>", ":close<Return>")

-- horizontal scroll
vim.keymap.set("", "<S-ScrollWheelUp>", "4zh")
vim.keymap.set("", "<S-ScrollWheelDown>", "4zl")
vim.keymap.set("", "<S-Left>", "8zh")
vim.keymap.set("", "<S-Right>", "8zl")

-- disable search highlight
vim.keymap.set("n", "g<Return>", function()
	vim.cmd("noh")
end)

--- plugin settings and keybindings
-- telescope
require("telescope").setup({
	defaults = {
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
	return require("buffer_manager.ui").toggle_quick_menu()
end

local function save_buffers()
	vim.cmd("mksession .sesh.vim")
	print("Session saved to .sesh.vim. Open with `nvim -S .sesh.vim`")
end

local function live_grep()
	return require("telescope.builtin").live_grep()
end

local function live_grep_ignore_vcs()
	return require("telescope.builtin").live_grep({
		additional_args = {
			"-u"
		},
	})
end

local function mark_opener()
	return require("telescope.builtin").marks()
end

local function grug_far()
	return vim.cmd("GrugFar")
end

vim.keymap.set("", "<leader>p", file_opener)
vim.keymap.set("", "<leader>P", file_opener_ignore_vcs)
vim.keymap.set("", "<leader>b", buffer_opener)
vim.keymap.set("", "<leader>B", save_buffers)
vim.keymap.set("", "<leader>f", live_grep)
vim.keymap.set("", "<leader>F", live_grep_ignore_vcs)
vim.keymap.set("", "<leader>r", grug_far)
vim.keymap.set("", "<leader>m", mark_opener)

-- center window
local function toggle_window_centering()
	require("no-neck-pain").setup({
		width = 150,
	})
	vim.cmd("NoNeckPain")
end

local function toggle_presentation_mode()
	require("no-neck-pain").setup({
		width = 80,
	})
	vim.cmd("NoNeckPain")
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

-- syntax
vim.keymap.set("", "<leader>i", function()
	vim.cmd("Inspect")
end)

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

-- file management shortcuts
local function copy_file(new_name)
	vim.cmd("f " .. new_name)
	vim.cmd("w")
end

local function edit_here(opts)
	local current_dir = vim.fn.expand("%:p:h")
	local name = opts.fargs[1]

	local new_file = current_dir .. "/" .. name
	vim.cmd("e " .. new_file)
end

vim.api.nvim_create_user_command("Edit", edit_here, { nargs = 1 })
vim.api.nvim_create_user_command("E", edit_here, { nargs = 1 })

vim.api.nvim_create_user_command("Mv", function(opts)
	local old_name = vim.fn.expand("%")
	local current_dir = vim.fn.expand("%:p:h")
	local new_name = opts.fargs[1]
	copy_file(current_dir .. "/" .. new_name)
	vim.cmd("!rm " .. old_name)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Rm", function(opts)
	local current_file = vim.fn.expand("%")
	local current_dir = vim.fn.expand("%:p:h")
	local to_delete = current_dir .. "/" .. current_file

	local answer = vim.fn.input("Really delete " .. to_delete .. "? (type \"yes\" to delete) ")
	if answer ~= "yes" then
		vim.cmd("!echo")
		return
	end

	vim.cmd("bd")
	vim.cmd("!rm " .. to_delete)
	vim.cmd("echo \"Deleted " .. to_delete .. "\"")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Cp", function(opts)
	local current_dir = vim.fn.expand("%:p:h")
	local new_name = opts.fargs[1]
	copy_file(current_dir .. "/" .. new_name)
end, { nargs = 1 })

-- show :messages in a new buffer and switch back to current window
function show_messages_buffer()
	vim.cmd("Messages")
	vim.cmd("wincmd p")
end
vim.keymap.set("", "<leader>M", show_messages_buffer)

-- import a snippet from a snippet directory
do
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local previewers = require("telescope.previewers")
	local conf = require("telescope.config").values

	local snippet_dir = vim.fn.expand("~/Code/helpers")
	local function absolute_path(dir, path)
		return "/" .. dir .. "/" .. path
	end

	local function insert_snippet(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		actions.close(prompt_bufnr)
		if selection and selection.value then
			local snippet_lines = vim.fn.readfile(selection.value)
			vim.api.nvim_put(snippet_lines, "", true, true)
		end
	end

	local function snippet_manager()
		pickers.new({ cwd = snippet_dir }, {
			prompt_title = "Snippet Manager",
			finder = finders.new_oneshot_job(
				{ "rg", "--files" },
				{
					cwd = snippet_dir,
					entry_maker = function(entry)
						return {
							value = absolute_path(snippet_dir, entry),
							ordinal = entry,
							display = entry,
						}
					end,
				}
			),
			sorter = conf.generic_sorter({}),
			previewer = previewers.vim_buffer_cat.new({}),
			layout_strategy = "horizontal",
			layout_config = {
				preview_width = 0.5,
				height = 0.8,
			},
			attach_mappings = function(_, map)
				map("i", "<CR>", insert_snippet)
				map("n", "<CR>", insert_snippet)
				return true
			end,
		}):find()
	end
	vim.keymap.set("", "<leader>n", snippet_manager)
end
