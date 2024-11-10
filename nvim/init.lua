-- plugins
require 'paq' {
  'savq/paq-nvim',

  'rktjmp/lush.nvim',
  'zenbones-theme/zenbones.nvim',

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

  'Shougo/context_filetype.vim',
  'tweekmonster/django-plus.vim',
  'terrastruct/d2-vim',

  'folke/trouble.nvim',
  'nvim-tree/nvim-web-devicons',

  'dgagn/diagflow.nvim',
}

-- plugin settings
require('telescope').setup {
  defaults = {
    preview = false,
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
vim.api.nvim_set_keymap('n', '<leader>w', ':WindowPick<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>W', ':WindowSwap<CR>', {})


-- treesitter
local nvim_treesitter = require('nvim-treesitter.configs')

vim.treesitter.language.register('html', 'jinja')
vim.treesitter.language.register('html', 'jinja2')

vim.treesitter.language.register('hcl', 'terraform')
vim.treesitter.language.register('hcl', 'tfvars')

nvim_treesitter.setup({
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
    "c",
    "cpp",
    "python",
    "bash",
    "lua",
    "hcl",
  },
  matchup = {
    enable = true,
  }
})

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
vim.cmd("syntax on")

vim.cmd("autocmd FocusGained * checktime")

vim.opt.list = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.api.nvim_create_augroup('setIndent', { clear = true })
vim.api.nvim_create_autocmd({'Filetype'}, {
  group = 'setIndent',
  pattern = { 'css', 'html', 'javascript',
    'lua', 'markdown', 'md', 'typescript',
    'scss', 'xml', 'xhtml', 'yaml', 'jinja'
  },
  command = 'setlocal shiftwidth=2 tabstop=2'
})

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

-- rename file
vim.api.nvim_create_user_command('Rn', function(opts)
  local old_name = vim.fn.expand('%')
  local new_name = opts.fargs[1]
  vim.api.nvim_exec2('f '..new_name, {})
  vim.api.nvim_exec2('w', {})
  vim.api.nvim_exec2('!rm '..old_name, {})
end, { nargs = 1 })

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
vim.keymap.set('', '<C-\\>' , "<C-^>")	-- navigate to MRU buffer
vim.keymap.set('', '<leader><BS>', ':bp | vsp | bn | bd!<CR>')		-- delete current buffer

vim.keymap.set('', '<leader>p' , ":lua require'telescope.builtin'.find_files{hidden = true}<CR>")
vim.keymap.set('', '<leader>P' , ":lua require'telescope.builtin'.find_files{hidden = true, no_ignore = true}<CR>")
vim.keymap.set('', '<leader>b', ":lua require'telescope.builtin'.buffers{}<CR>")
vim.keymap.set('', '<leader><Tab>', ":lua require'telescope.builtin'.buffers{}<CR>")
vim.keymap.set('', '<leader>f', ":lua require'telescope.builtin'.live_grep{}<CR>")

vim.keymap.set('', '<leader>t' , ":Trouble diagnostics toggle<CR>")

-- window navigation
vim.keymap.set('', '<C-h>', '<C-w>h')
vim.keymap.set('', '<C-j>', '<C-w>j')
vim.keymap.set('', '<C-k>', '<C-w>k')
vim.keymap.set('', '<C-l>', '<C-w>l')

vim.keymap.set('i', '<C-h>', '<Esc><C-w>h')
vim.keymap.set('i', '<C-j>', '<Esc><C-w>j')
vim.keymap.set('i', '<C-k>', '<Esc><C-w>k')
vim.keymap.set('i', '<C-l>', '<Esc><C-w>l')

-- horizontal scroll
vim.keymap.set('', '<S-ScrollWheelUp>',   '4zh')
vim.keymap.set('', '<S-ScrollWheelDown>', '4zl')
vim.keymap.set('', '<S-Left>',            '8zh')
vim.keymap.set('', '<S-Right>',           '8zl')

-- terminal normal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

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

