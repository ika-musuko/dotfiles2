-- plugins
require 'paq' {
  'savq/paq-nvim',

  'rktjmp/lush.nvim',
  'zenbones-theme/zenbones.nvim',
  'sainnhe/everforest',
  'kadekillary/skull-vim',
  'danishprakash/vim-yami',

  'nvim-treesitter/nvim-treesitter',

  'andymass/vim-matchup',
  'bullets-vim/bullets.vim',

  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-abolish',
  'tpope/vim-sleuth',

  'LunarVim/bigfile.nvim',

  'sitiom/nvim-numbertoggle',
  'vimlab/split-term.vim',
  'szw/vim-maximizer',
  'shortcuts/no-neck-pain.nvim',
  'ten3roberts/window-picker.nvim',

  'nvim-lua/plenary.nvim', -- needed for telescope
  'nvim-telescope/telescope-fzf-native.nvim',
  'nvim-telescope/telescope.nvim',
  'mcchrish/nnn.vim',

  'pangloss/vim-javascript',
  'jonsmithers/vim-html-template-literals',
  'HerringtonDarkholme/yats.vim',
  'Shougo/context_filetype.vim',
  'sophacles/vim-bundle-mako',
  'hashivim/vim-terraform',
  'tweekmonster/django-plus.vim',
  'Glench/Vim-Jinja2-Syntax',
  'terrastruct/d2-vim',

  'neovim/nvim-lspconfig',
  'ms-jpq/coq_nvim',

  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  'github/copilot.vim',

  'folke/trouble.nvim',
  'nvim-tree/nvim-web-devicons',

  'dgagn/diagflow.nvim',

  'ThePrimeagen/vim-be-good',
}

-- plugin settings
require('telescope').setup {
  defaults = {
    layout_config = {
      horizontal = {
        height = 0.8
      },
      vertical = {
        height = 0.8
      },
    }
  },
  pickers = {
    find_files = {
      disable_devicons = false
    },
    colorscheme = {
      enable_preview = true,
    },
  },
}

-- window-picker
require'window-picker'.setup{
  keys = 'asdfvrcexwzqgbthnyjmukilop',
  swap_shift = true,
  exclude = { qf = true, NvimTree = true, aerial = true },
  hide_other_statuslines = false,
}
vim.api.nvim_set_keymap('n', '<leader>[', ':WindowPick<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>]', ':WindowSwap<CR>', {})

-- nnn
vim.g['nnn#replace_netrw'] = 1
vim.g['nnn#command'] = 'nnn -C'

-- copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<S-Down>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- emmet
vim.g.user_emmet_leader_key = '<C-X>'

-- treesitter
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    disable = function(_, bufnr)
        return vim.api.nvim_buf_line_count(bufnr) > 5000
    end,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  ensure_installed = {
    "html", "css", "javascript",
    "elixir",
    "cpp",
  },
  matchup = {
    enable = true,
  }
})

-- use htmldjango indent for jinja
local jinja_indent_group = vim.api.nvim_create_augroup("jinja_indent", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = jinja_indent_group,
  pattern = "jinja",
  callback = function()
    vim.bo.indentexpr = "htmldjango#indent()"
  end,
})

-- lsp
vim.diagnostic.config({
  virtual_text = false,
})


require('trouble').setup()

require('diagflow').setup()

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', }
})

local on_attach = function(_, _)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, {})

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gD', function()
    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    if win_width > win_height * 4 then
      vim.cmd('vsplit')
    else
      vim.cmd('split')
    end

    vim.lsp.buf.definition()
  end, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})

  vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, {})
  vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, {})

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end


local lsp = require('lspconfig')
local coq = require('coq')

local on_attach_spaces = function(tab_width)
  return function(client, bufnr)
    if client.name == 'clangd' then
      vim.bo[bufnr].tabstop = tab_width
      vim.bo[bufnr].shiftwidth = tab_width
      vim.bo[bufnr].expandtab = true
    end
    on_attach()
  end
end

-- lua
lsp.lua_ls.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'},
      },
    },
  },
}))

-- c++
lsp.clangd.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach_spaces(4)
}))
lsp.bzl.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach }))
lsp.cmake.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach }))

lsp.cssls.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
}))

lsp.html.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
}))

lsp.pylsp.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
  settings = {
    pylsp = {
      plugins = {
        pylint = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false }
      }
    }
  },
}))

-- cursor settings
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

-- color scheme
vim.o.termguicolors = true
vim.opt.background = 'dark'

vim.g.forestbones_lighten_comments = 60
vim.cmd('colorscheme forestbones')
vim.cmd('set t_Co=256')
vim.cmd('highlight Cursor ctermbg=8')

vim.cmd('highlight! LineNr ctermfg=15')
vim.cmd('highlight! link @string.special.url.html String')
vim.cmd('highlight! link @tag.html Type')
vim.cmd('highlight! link @tag.delimiter.html Type')
vim.cmd('highlight! link @tag.attribute @attribute')

vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')
vim.cmd('highlight LineNr ctermbg=NONE guibg=NONE')


-- environment settings
vim.cmd("syntax enable")

vim.cmd("autocmd FocusGained * checktime")

vim.opt.list = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.clipboard = 'unnamedplus'

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

vim.keymap.set('n', '<C-\\>', ':noh<CR>')
vim.keymap.set('n', 'g<Return>', ':noh<CR>')

-- commands
-- uppercase corrections
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Sp', 'sp', {})
vim.api.nvim_create_user_command('Vsp', 'vsp', {})

-- trim whitespace at end of lines
local function trim_whitespace()
  local save = vim.fn.winsaveview()
  vim.api.nvim_exec('%s/\\s\\+$//e', false)
  vim.fn.winrestview(save)
end

vim.api.nvim_create_user_command('TrimWhitespace', trim_whitespace, {})
vim.keymap.set('', '<leader>s', ':TrimWhitespace<CR>')

-- terminal
vim.keymap.set('', '<leader>e', ':Term<CR>')

-- center window
require('no-neck-pain').setup({
  width = 150
})
vim.keymap.set('', '<leader>g', ':NoNeckPain<CR>')

-- maximizer
vim.keymap.set('', '<leader>z', ':MaximizerToggle<CR>')

-- config keybindings
-- neovim configs
local init_file = '~/.config/nvim/init.lua'
local refresh_cmd = ':so ' .. init_file .. '<CR>'
vim.keymap.set('n', '<leader>,e', ':e ' .. init_file .. '<CR>')
vim.keymap.set('n', '<leader>,r', refresh_cmd)
vim.keymap.set('n', '<leader>,p', refresh_cmd .. ':PaqSync<CR>')

-- other configs
local conf_files = {
  kitty = '~/.config/kitty/kitty.conf',
  tmux = '~/.tmux.conf',
  vim = '~/.config/nvim/init.lua',
  zsh = '~/.zshrc',
}

local function open_conf(conf)
  return function()
    vim.api.nvim_command('e ' .. conf)
  end
end

for name, file in pairs(conf_files) do
  vim.api.nvim_create_user_command('Cf' .. name, open_conf(file), {})
end

-- buffer keybindings
vim.keymap.set('', '<leader><leader>' , "<C-^>")	-- navigate to MRU buffer
vim.keymap.set('', '<leader><BS>', ':bp | vsp | bn | bd!<CR>')		-- delete current buffer

vim.keymap.set('', '<leader>p' , ":lua require'telescope.builtin'.find_files{hidden = true}<CR>")
vim.keymap.set('', '<leader>P' , ":lua require'telescope.builtin'.find_files{hidden = true, no_ignore = true}<CR>")
vim.keymap.set('', '<leader>b', ":lua require'telescope.builtin'.buffers{}<CR>")
vim.keymap.set('', '<leader>f', ":lua require'telescope.builtin'.live_grep{}<CR>")

vim.keymap.set('', '<leader>t' , ":Trouble diagnostics toggle<CR>")

-- window navigation
vim.keymap.set('', '<C-h>', '<C-w>h')
vim.keymap.set('', '<C-j>', '<C-w>j')
vim.keymap.set('', '<C-k>', '<C-w>k')
vim.keymap.set('', '<C-l>', '<C-w>l')
vim.keymap.set('', '<C-p>', '<C-w>p')

vim.keymap.set('i', '<C-h>', '<Esc><C-w>h')
vim.keymap.set('i', '<C-j>', '<Esc><C-w>j')
vim.keymap.set('i', '<C-k>', '<Esc><C-w>k')
vim.keymap.set('i', '<C-l>', '<Esc><C-w>l')
vim.keymap.set('i', '<C-p>', '<Esc><C-w>p')

-- horizontal scroll
vim.keymap.set('', '<S-ScrollWheelUp>',   '4zh')
vim.keymap.set('', '<S-ScrollWheelDown>', '4zl')
vim.keymap.set('', '<S-Left>',            '8zh')
vim.keymap.set('', '<S-Right>',           '8zl')

-- terminal normal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- surround
vim.keymap.set('', '<leader>\'', 'ysw\'')
vim.keymap.set('', '<leader>"', 'ysw\"')
vim.keymap.set('', '<leader>/\'', 'ysW\'')
vim.keymap.set('', '<leader>/"', 'ysW\"')

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

vim.api.nvim_create_autocmd({"CursorMoved", "InsertLeave"}, {
  pattern = "*",
  callback = function()
    if vim.g.force_cursor_center then
      vim.api.nvim_command('normal! zz')
    end
  end
})

vim.api.nvim_create_user_command('ToggleCenter', toggle_cursor_center, {})
vim.keymap.set('', '<leader>c', ':ToggleCenter<CR>')

-- set filetype shortcut
vim.api.nvim_create_user_command('F', function(opts)
  vim.bo.filetype = opts.fargs[1]
end, { nargs = 1 })


-- insert agenda for sagyou.md
vim.keymap.set('n', '<leader>8', ':r!~/Scripts/agenda yesterday today<CR>')
vim.keymap.set('n', '<leader>9', ':r!~/Scripts/agenda today tomorrow<CR>')
vim.keymap.set('n', '<leader>0', ':r!~/Scripts/agenda tomorrow 2days<CR>')
vim.keymap.set('n', '<leader>2', ':r!~/Scripts/agenda 2days 3days<CR>')
