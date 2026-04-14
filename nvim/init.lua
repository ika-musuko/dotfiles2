-- requires neovim v0.12+
vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/j-morano/buffer_manager.nvim",
    "https://github.com/MagicDuck/grug-far.nvim",

    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim", --build = "make"
    "https://github.com/nvim-telescope/telescope.nvim",

    "https://github.com/bullets-vim/bullets.vim",
    "https://github.com/leafOfTree/vim-matchtag",
    "https://github.com/ika-musuko/vim-surround",
    "https://github.com/tpope/vim-repeat",
    "https://github.com/tpope/vim-abolish",
    "https://github.com/tpope/vim-fugitive",

    "https://github.com/nvim-treesitter/nvim-treesitter", -- branch = "main", build = ":TSUpdate"
    "https://github.com/Shougo/context_filetype.vim",
    "https://github.com/leafOfTree/vim-svelte-plugin",
    "https://github.com/leafOfTree/vim-vue-plugin",
    "https://github.com/terrastruct/d2-vim",
    "https://github.com/zorab47/procfile.vim",
})

-- init
pcall(function()
    local telescope = require("telescope")
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
    pcall(telescope.load_extension, "fzf")
end)

pcall(function()
    require("oil").setup({
        float = {
            border = "rounded",
            max_width = 0.5,
            max_height = 0.5,
        }
    })
end)

pcall(function()
    local treesitter_configs = require("nvim-treesitter.configs")
    treesitter_configs.setup({
        ensure_installed = {
            "python",
            "c",
            "cpp",
            "markdown",
            "html",
            "css",
            "javascript",
            "typescript",
        },
    })
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
        "c",
        "sh",
        "bash",
        "zsh",
        "python",
        "lua",
        "cpp",
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

pcall(function()
    vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
            local bufnr = args.buf

            if not vim.api.nvim_buf_is_loaded(bufnr) then
                return
            end

            if vim.bo[bufnr].buftype ~= "" then
                return
            end

            local ok, parser = pcall(vim.treesitter.get_parser, bufnr, nil)
            if not ok or not parser then
                return
            end

            pcall(vim.treesitter.start, bufnr)

            local ok_indent = pcall(function()
                vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end)
            if not ok_indent then
                return
            end
        end,
    })
end)

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
    vim.api.nvim_set_hl(0, "Visual", { ctermfg = none, ctermbg = brightblack })

    vim.api.nvim_set_hl(0, "StatusLine", { ctermfg = green, ctermbg = brightblack })
    vim.api.nvim_set_hl(0, "StatusLineNC", { ctermfg = none, ctermbg = brightblack })

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
    vim.api.nvim_set_hl(0, "Comment", { ctermfg = brightgreen })
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
    local h3 = yellow
    local h4 = brightyellow
    -- treesitter markdown
    vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { ctermfg = h1 })
    vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { ctermfg = h2 })
    vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { ctermfg = h3 })
    vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { ctermfg = h4 })
    vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { ctermfg = brightwhite })
    -- vanilla markdown
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

vim.opt.title = true
vim.opt.titlestring = "%F"

--- native keybindings
-- config keybindings and commands
do
    local init_file = "~/.config/nvim/init.lua"

    local function reload_config()
        vim.cmd.source(init_file)
    end

    vim.keymap.set("n", "<M-/>", reload_config)
    vim.keymap.set("n", "<D-/>", reload_config)
end


-- window navigation
local function hybrid_navigate(direction)
    return function()
        local prev_win = vim.api.nvim_get_current_win()
        vim.cmd("wincmd " .. direction)

        if
            prev_win == vim.api.nvim_get_current_win()
            and os.getenv("TMUX")
            and vim.fn.system({"tmux", "display-message", "-p", "#{window_zoomed_flag}"}) ~= "1\n" then
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


local function copy_current_filepath()
    local path = vim.fn.expand("%:p")
    if path == "" then
        print("Could not copy path")
        return
    end
    print(path)
    vim.fn.setreg("+", path)
end

local function open_oil()
    require("oil").open()
end

vim.keymap.set("", "<leader>e", open_oil)
vim.keymap.set("", "<leader>p", file_opener)
vim.keymap.set("", "<leader>P", file_opener_ignore_vcs)
vim.keymap.set("", "<leader>b", buffer_opener)
vim.keymap.set("", "<leader>B", save_buffers)
vim.keymap.set("", "<leader>f", grug_far)
vim.keymap.set("", "<leader>m", mark_opener)
vim.keymap.set("", "<leader>Y", copy_current_filepath)


--- custom commands and keybindings
-- uppercase corrections
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Sp", "sp", {})
vim.api.nvim_create_user_command("Vsp", "vsp", {})


-- buffers
vim.keymap.set("", "<C-q>", ":bd!<CR>")


-- syntax
vim.keymap.set("", "<leader>i", function()
    vim.cmd("Inspect")
end)

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

-- open current oil directory in finder
vim.api.nvim_create_user_command("OilFinder", function()
    local ok, oil = pcall(require, "oil")
    if ok then
        local dir = oil.get_current_dir()
        if dir then
            vim.fn.system({ "open", dir })
            return
        end
    end
    vim.fn.system({ "open", vim.fn.getcwd() })
end, {})

-- import a snippet from a snippet directory
pcall(function()
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
end)

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


    vim.api.nvim_create_user_command("Gh", function() OpenGitHubLink("commit") end, { nargs = 0 })
end

--- Custom Tree File Navigator
do
    local ns = vim.api.nvim_create_namespace("custom_tree")
    local tree_buf = nil
    local expanded_dirs = {}
    local extmark_map = {} -- Stores id -> { path, type } mapping
    local tree_cwd = ""

    local fs_watchers = {}
    local redraw_timer = nil

    local function clear_watchers()
        for _, watcher in ipairs(fs_watchers) do
            if watcher and not watcher:is_closing() then
                watcher:stop()
                watcher:close()
            end
        end
        fs_watchers = {}
    end

    local draw_tree -- Forward declaration

    -- Redraw debouncer to prevent flickering on bulk edits
    local function debounced_redraw()
        if redraw_timer then
            redraw_timer:stop()
            redraw_timer:close()
        end
        redraw_timer = vim.uv.new_timer()
        redraw_timer:start(50, 0, vim.schedule_wrap(function()
            if tree_buf and vim.api.nvim_buf_is_valid(tree_buf) then
                -- Only redraw if the user hasn't made unsaved edits
                if not vim.bo[tree_buf].modified then
                    draw_tree()
                end
            else
                clear_watchers()
            end
        end))
    end

    local function setup_watchers()
        clear_watchers()
        if not tree_cwd or tree_cwd == "" then return end

        local dirs_to_watch = { tree_cwd }
        for dir, is_expanded in pairs(expanded_dirs) do
            if is_expanded then table.insert(dirs_to_watch, dir) end
        end

        for _, dir in ipairs(dirs_to_watch) do
            local watcher = vim.uv.new_fs_event()
            if watcher then
                watcher:start(dir, {}, function(err, filename, events)
                    if err then return end
                    debounced_redraw()
                end)
                table.insert(fs_watchers, watcher)
            end
        end
    end

    -- Fetch directory tree lines recursively
    local function get_tree_lines(dir, depth)
        local lines = {}
        local meta = {}

        local handle = vim.uv.fs_scandir(dir)
        if not handle then return lines, meta end

        local entries = {}
        while true do
            local name, type = vim.uv.fs_scandir_next(handle)
            if not name then break end
            table.insert(entries, { name = name, type = type })
        end

        -- Sort: directories first, then files alphabetically
        table.sort(entries, function(a, b)
            if a.type == b.type then return a.name < b.name end
            return a.type == "directory"
        end)

        for _, entry in ipairs(entries) do
            local path = dir .. "/" .. entry.name
            local is_dir = entry.type == "directory"
            local line_str = string.rep("  ", depth) .. entry.name .. (is_dir and "/" or "")

            table.insert(lines, line_str)
            table.insert(meta, { path = path, type = entry.type, depth = depth, name = entry.name })

            if is_dir and expanded_dirs[path] then
                local sub_lines, sub_meta = get_tree_lines(path, depth + 1)
                for _, l in ipairs(sub_lines) do table.insert(lines, l) end
                for _, m in ipairs(sub_meta) do table.insert(meta, m) end
            end
        end

        return lines, meta
    end

    -- Render the tree into the buffer and attach extmarks
    draw_tree = function()
        if not tree_buf or not vim.api.nvim_buf_is_valid(tree_buf) then return end

        local lines, meta = get_tree_lines(tree_cwd, 0)

        vim.bo[tree_buf].modifiable = true
        vim.api.nvim_buf_set_lines(tree_buf, 0, -1, false, lines)
        vim.api.nvim_buf_clear_namespace(tree_buf, ns, 0, -1)

        extmark_map = {}
        local has_devicons, devicons = pcall(require, "nvim-web-devicons")

        for i, m in ipairs(meta) do
            local is_dir = m.type == "directory"
            local icon, icon_hl
            local text_hl = is_dir and "Directory" or "Normal"

            if is_dir then
                icon = expanded_dirs[m.path] and "▼ " or "▶ "
                icon_hl = "Directory"
            else
                if has_devicons then
                    local ext = m.name:match("^.+%.(.+)$") or ""
                    local devicon, devhl = devicons.get_icon(m.name, ext, { default = true })
                    icon = (devicon or "📄") .. " "
                    icon_hl = devhl or "Normal"
                else
                    icon = "📄 "
                    icon_hl = "Normal"
                end
            end

            local indent_len = m.depth * 2
            local id = vim.api.nvim_buf_set_extmark(tree_buf, ns, i - 1, indent_len, {
                virt_text = { { icon, icon_hl } },
                virt_text_pos = "inline",
                hl_group = text_hl,
                end_row = i - 1,
                end_col = indent_len + #m.name + (is_dir and 1 or 0),
            })
            extmark_map[id] = m
        end

        vim.bo[tree_buf].modified = false
        setup_watchers()
    end

    -- Handle <CR> on a node
    local function toggle_or_open()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local extmarks = vim.api.nvim_buf_get_extmarks(tree_buf, ns, {row, 0}, {row, -1}, {})

        if #extmarks == 0 then return end
        local id = extmarks[1][1]
        local m = extmark_map[id]

        if not m then return end

        if m.type == "directory" then
            expanded_dirs[m.path] = not expanded_dirs[m.path]
            draw_tree()
            vim.api.nvim_win_set_cursor(0, cursor)
        else
            vim.cmd("wincmd p") -- Return to previous window
            vim.cmd("e " .. vim.fn.fnameescape(m.path))
        end
    end

    -- Perform file operations (Create, Rename, Delete) like oil.nvim
    local function apply_changes()
        local lines = vim.api.nvim_buf_get_lines(tree_buf, 0, -1, false)
        local current_extmarks = vim.api.nvim_buf_get_extmarks(tree_buf, ns, 0, -1, { details = true })

        local seen_ids = {}
        local line_to_id = {}
        for _, mark in ipairs(current_extmarks) do
            local id, row = mark[1], mark[2]
            seen_ids[id] = true
            line_to_id[row] = id
        end

        -- 1. Handle Deletions (Extmark existed, but line was removed)
        for id, m in pairs(extmark_map) do
            if not seen_ids[id] then
                if vim.fn.delete(m.path, "rf") ~= 0 then
                    vim.notify("Failed to delete " .. m.path, vim.log.levels.ERROR)
                else
                    vim.notify("Deleted " .. m.path, vim.log.levels.INFO)
                end
            end
        end

        -- 2. Handle Renames, Moves, and Creations
        local stack = { [0] = tree_cwd }
        for row, line in ipairs(lines) do
            if line:match("%S") then
                local indent_str = line:match("^(%s*)")
                local indent = #indent_str
                local depth = math.floor(indent / 2)

                local name = line:sub(indent + 1)
                local is_dir = false
                if name:sub(-1) == "/" then
                    is_dir = true
                    name = name:sub(1, -2)
                end

                local parent_path = stack[depth] or tree_cwd
                local new_path = parent_path .. "/" .. name
                stack[depth + 1] = new_path

                local id = line_to_id[row - 1]
                if id and extmark_map[id] then
                    -- Existed previously -> Check for rename or move
                    local old_path = extmark_map[id].path
                    if old_path ~= new_path then
                        local success, err = vim.uv.fs_rename(old_path, new_path)
                        if success then
                            vim.notify("Renamed to " .. new_path, vim.log.levels.INFO)
                            -- Update state if moving expanded directory
                            if extmark_map[id].type == "directory" and expanded_dirs[old_path] then
                                expanded_dirs[old_path] = nil
                                expanded_dirs[new_path] = true
                            end
                        else
                            vim.notify("Failed to rename: " .. err, vim.log.levels.ERROR)
                        end
                    end
                else
                    -- No Extmark -> New line -> Create file/dir
                    if is_dir then
                        vim.fn.mkdir(new_path, "p")
                        vim.notify("Created directory " .. new_path, vim.log.levels.INFO)
                    else
                        local fd = vim.uv.fs_open(new_path, "w", 438) -- 0666
                        if fd then
                            vim.uv.fs_close(fd)
                            vim.notify("Created file " .. new_path, vim.log.levels.INFO)
                        end
                    end
                end
            end
        end

        draw_tree()
    end

    local function open_tree()
        tree_cwd = vim.fn.getcwd()

        if tree_buf and vim.api.nvim_buf_is_valid(tree_buf) then
            local win = vim.fn.bufwinnr(tree_buf)
            if win ~= -1 then
                vim.cmd(win .. "wincmd w")
                return
            end
            vim.cmd("vsplit")
            vim.api.nvim_win_set_buf(0, tree_buf)
            draw_tree()
            return
        end

        tree_buf = vim.api.nvim_create_buf(false, true)
        vim.bo[tree_buf].buftype = "acwrite"
        vim.bo[tree_buf].filetype = "custom_tree"
        vim.bo[tree_buf].swapfile = false

        -- Clean up watchers on wipeout
        vim.api.nvim_create_autocmd("BufWipeout", {
            buffer = tree_buf,
            callback = function()
                clear_watchers()
                if redraw_timer then
                    redraw_timer:stop()
                    redraw_timer:close()
                    redraw_timer = nil
                end
            end
        })

        -- Keymaps local to tree
        vim.keymap.set("n", "<CR>", toggle_or_open, { buffer = tree_buf, desc = "Toggle dir or open file" })
        vim.keymap.set("n", "q", ":bd<CR>", { buffer = tree_buf, silent = true, desc = "Close tree" })

        -- Hijack :w to apply modifications to filesystem
        vim.api.nvim_create_autocmd("BufWriteCmd", {
            buffer = tree_buf,
            callback = function()
                apply_changes()
            end,
        })

        vim.cmd("vsplit")
        vim.api.nvim_win_set_buf(0, tree_buf)

        -- Buffer visuals
        vim.opt_local.wrap = false
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = true

        draw_tree()
    end

    vim.keymap.set("n", "<leader>t", open_tree, { desc = "Open Custom Tree Navigator" })
end
