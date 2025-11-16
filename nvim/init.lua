-- auto-install paq
local install_path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim", install_path })
end

require("paq")({
	"savq/paq-nvim",

	"MagicDuck/grug-far.nvim",
	"j-morano/buffer_manager.nvim",

	"bullets-vim/bullets.vim",
	"leafOfTree/vim-matchtag",
	"justinmk/vim-matchparenalways",
	"ika-musuko/vim-surround",
	"tpope/vim-repeat",
	"tpope/vim-abolish",

	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"nvim-telescope/telescope.nvim",

	"Shougo/context_filetype.vim",
	"leafOfTree/vim-svelte-plugin",
	"leafOfTree/vim-vue-plugin",
	"terrastruct/d2-vim",
	"zorab47/procfile.vim",
})

pcall(function()
	local telescope = require("telescope")
	telescope.setup({})
	pcall(telescope.load_extension, "fzf")
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
		"cpp",
		"c",
		"java",
		"groovy",
		"json",
		"cucumber",
		"markdown",
		"python",
		"sh",
		"bash",
		"zsh",
	},
	callback = function()
		set_indent({ width = 4 })
	end,
})

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


-- language highlighting
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
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "c", "cpp" },
		callback = function()
			vim.cmd([[
				syntax keyword cSizedNumericTypes u8 s8 u16 s16 u32 s32 u64 s64 f32 f64
				highlight def link cSizedNumericTypes Type
			]])
		end,
	})

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

	-- shell
	vim.cmd("hi link @variable.bash Constant")
end

--- environment settings
vim.cmd("autocmd FocusGained * checktime")

vim.opt.list = true
vim.opt.clipboard = "unnamedplus"

vim.opt.number = false
vim.opt.relativenumber = false
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

-- window navigation
local function hybrid_navigate(direction)
	return function()
		local prev_win = vim.api.nvim_get_current_win()
		vim.cmd("wincmd " .. direction)

		if
			prev_win == vim.api.nvim_get_current_win()
			and os.getenv("TMUX")
			-- encapsulating tmux pane is zoomed, don't fire off to tmux
			-- because having the other windows open by default on navigation is annoying
			and vim.fn.system({"tmux", "display-message", "-p", "#{window_zoomed_flag}"}) ~= "1\n"
		then
			local tmux_direction = ({
				h = "L",
				j = "D",
				k = "U",
				l = "R"
			})[direction]

			vim.fn.system({"tmux", "select-pane", "-" .. tmux_direction})
		end
	end
end

vim.keymap.set("", "<C-h>", hybrid_navigate("h"))
vim.keymap.set("", "<C-j>", hybrid_navigate("j"))
vim.keymap.set("", "<C-k>", hybrid_navigate("k"))
vim.keymap.set("", "<C-l>", hybrid_navigate("l"))

vim.keymap.set("i", "<C-h>", "<Esc><C-w>h")
vim.keymap.set("i", "<C-j>", "<Esc><C-w>j")
vim.keymap.set("i", "<C-k>", "<Esc><C-w>k")
vim.keymap.set("i", "<C-l>", "<Esc><C-w>l")

vim.keymap.set("n", "<M-f>", "<C-w><C-w>")
vim.keymap.set("n", "<M-g>", "<C-6>")

-- horizontal scroll
vim.keymap.set("", "<S-ScrollWheelUp>", "4zh")
vim.keymap.set("", "<S-ScrollWheelDown>", "4zl")
vim.keymap.set("", "<S-Left>", "8zh")
vim.keymap.set("", "<S-Right>", "8zl")

-- terminal normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

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

local function grug_far()
	vim.cmd("GrugFar")
end


local function mark_opener()
	return require("telescope.builtin").marks()
end

vim.keymap.set("", "<leader>p", file_opener)
vim.keymap.set("", "<leader>P", file_opener_ignore_vcs)
vim.keymap.set("", "<leader>b", buffer_opener)
vim.keymap.set("", "<leader>B", save_buffers)
vim.keymap.set("", "<leader>f", grug_far)
vim.keymap.set("", "<leader>m", mark_opener)

--- custom commands and keybindings
-- uppercase corrections
vim.api.nvim_create_user_command("Q", "q", {})
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

-- GitHub links
do
	local function sh(cmd)
		local out = vim.fn.systemlist(cmd)
		if vim.v.shell_error ~= 0 or not out or #out == 0 then return nil end
		return vim.fn.trim(out[1])
	end

	-- Normalize remote URL to https://host/owner/repo
	local function to_https(remote)
		if not remote then return nil end
		remote = remote:gsub("%.git$", "")

		-- git@host:owner/repo
		local host, path = remote:match("^git@([^:]+):(.+)$")
		if host and path then return ("https://%s/%s"):format(host, path) end

		-- ssh://git@host/owner/repo
		host, path = remote:match("^ssh://git@([^/]+)/(.+)$")
		if host and path then return ("https://%s/%s"):format(host, path) end

		-- https already (GitHub or GHE)
		if remote:match("^https?://") then return remote end

		return nil
	end

	-- Pick revision: commit (default) or branch
	local function get_rev(mode)
		mode = mode or "commit"
		if mode == "branch" then
			local br = sh("git rev-parse --abbrev-ref HEAD")
			if br and br ~= "HEAD" then return br end
		end
		return sh("git rev-parse HEAD")
	end

	local function build_github_url(opts)
		opts = opts or {}
		local rev_mode = opts.rev_mode or "commit"

		local root = sh("git rev-parse --show-toplevel")
		if not root then return nil, "Not inside a Git repository." end

		local file_abs = vim.fn.expand("%:p")
		if file_abs == "" then return nil, "No file associated with this buffer." end

		local real_root = vim.loop.fs_realpath(root) or root
		local real_file = vim.loop.fs_realpath(file_abs) or file_abs

		if not vim.startswith(real_file, real_root) then
			return nil, "File is not under the repository root."
		end
		local rel = real_file:sub(#real_root + 2) -- strip trailing "/"

		local remote = sh("git remote get-url --push origin") or sh("git remote get-url origin")
		if not remote then return nil, "No git remote named 'origin' found." end

		local https = to_https(remote)
		if not https then return nil, ("Unsupported remote URL format: %s"):format(remote) end

		local rev = get_rev(rev_mode)
		if not rev then return nil, "Could not determine git revision." end

		local line = vim.api.nvim_win_get_cursor(0)[1]
		local url = ("%s/blob/%s/%s#L%d"):format(https, rev, rel, line)
		return url
	end

	local function open_in_browser(url)
		-- Neovim 0.10+ has vim.ui.open
		if vim.ui and vim.ui.open then
			vim.ui.open(url)
			return
		end

		local cmd
		if vim.fn.has("mac") == 1 then
			cmd = { "open", url }
		elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
			cmd = { "cmd", "/c", "start", url }
		else
			cmd = { "xdg-open", url }
		end
		vim.fn.jobstart(cmd, { detach = true })
	end

	local function OpenGitHubLink(mode)
		local url, err = build_github_url({ rev_mode = (mode == "branch") and "branch" or "commit" })
		if not url then
			vim.notify("GitHub open: " .. err, vim.log.levels.ERROR)
			return
		end
		open_in_browser(url)
	end

	-- Mappings
	vim.keymap.set("n", "<leader>g", function() OpenGitHubLink("commit") end,
		{ desc = "Open GitHub link (commit)" })
end
