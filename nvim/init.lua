-- plugins
require 'paq' {
  'savq/paq-nvim',

  'rebelot/kanagawa.nvim',
  'andreasvc/vim-256noir',

  'nvim-treesitter/nvim-treesitter',
  --'hiphish/rainbow-delimiters.nvim',
  'andymass/vim-matchup',

  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-abolish',
  'tpope/vim-sleuth',
  'dkarter/bullets.vim',

  'vimlab/split-term.vim',

  'folke/zen-mode.nvim',

  'iamcco/markdown-preview.nvim',

  'shortcuts/no-neck-pain.nvim',

  'nvim-lua/plenary.nvim', -- needed for telescope
  'nvim-telescope/telescope-fzf-native.nvim',
  'nvim-telescope/telescope.nvim',
  'mcchrish/nnn.vim',

  'pangloss/vim-javascript',
  'jonsmithers/vim-html-template-literals',
  'HerringtonDarkholme/yats.vim',
  'Shougo/context_filetype.vim',
  '73/vim-klog',
  'sophacles/vim-bundle-mako',
  'hashivim/vim-terraform',
  'tweekmonster/django-plus.vim',
  'Glench/Vim-Jinja2-Syntax',
  'mattn/emmet-vim',

  'neovim/nvim-lspconfig',

  'ms-jpq/coq_nvim',

  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  'github/copilot.vim',

  'folke/trouble.nvim',
  'nvim-tree/nvim-web-devicons',

  'dgagn/diagflow.nvim',
}

-- plugin settings
-- nnn
vim.g['nnn#replace_netrw'] = 1

-- copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<S-Down>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- emmet
vim.g.user_emmet_leader_key = '<C-X>'

-- treesitter
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  ensure_installed = {
    "html", "css", "javascript" -- or other languages you need
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

-- rainbow delimiters
--[[
local rainbow_delimiters = require('rainbow-delimiters')
---
require('rainbow-delimiters.setup').setup({
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 110,
        lua = 210,
    },
    highlight = {
        'RainbowDelimiterCyan',
        'RainbowDelimiterBlue',
        'RainbowDelimiterViolet',
    },
})

-- HACK: temporary fix to ensure rainbow delimiters are highlighted in real-time
vim.api.nvim_create_autocmd(
   "BufRead",
   {
      desc = "Ensure treesitter is initialized???",
      callback = function()
         -- if this fails then it means no parser is available for current buffer
         pcall(vim.treesitter.start)
      end,
   }
)
]]--

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
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})

  vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, {})
  vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, {})

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

vim.g.coq_settings = {
  auto_start = true,
}

local lsp = require('lspconfig')
local coq = require('coq')

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

lsp.bashls.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
}))

lsp.htmx.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
}))

lsp.cssls.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
}))

lsp.html.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
}))

lsp.pylsp.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
}))

--
--[[
lsp.pyright.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace"
      }
    }
  },
  root_dir = function(fname)
    return require('lspconfig.util').find_git_ancestor(fname) or require('lspconfig.util').path.dirname(fname)
  end
}))
]]--

-- cursor settings
vim.opt.guicursor = {
  'n-v-c:block',       -- Use a block cursor in normal, visual, and command modes
  'i-ci-ve:ver25',     -- Use a vertical bar cursor in insert and replace modes
  'r-cr:hor20',        -- Use a horizontal bar cursor in replace mode
  'o:hor50',           -- Use a wide horizontal bar in operator-pending mode
  'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor', -- Blinking cursor with specific timing
  'sm:block-blinkwait175-blinkoff150-blinkon175'          -- Use a blinking block cursor in select mode
}

-- color scheme
--vim.cmd('colorscheme kanagawa') -- just an init so we have kanagawa
--local kanagawa = require("kanagawa.colors").setup()

vim.opt.background = 'dark'
vim.o.termguicolors = true
vim.cmd('colorscheme kanagawa')
vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')
vim.cmd('highlight LineNr ctermbg=NONE guibg=NONE')

--vim.cmd('highlight! Number guifg=#dd8899')
--vim.cmd('highlight! String guifg=#889988')
vim.cmd('highlight! link @string.special.url.html String')
vim.cmd('highlight! link @tag.html Type')
vim.cmd('highlight! link @tag.delimiter.html Type')
vim.cmd('highlight! link @tag.attribute @attribute')

vim.cmd('highlight RainbowDelimiterCyan guifg=#4fcce2')
vim.cmd('highlight RainbowDelimiterBlue guifg=#4f83e2')
vim.cmd('highlight RainbowDelimiterViolet guifg=#8a76fc')


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

vim.keymap.set('n', '<Return>', ':noh<CR><Return>')

-- commands
vim.api.nvim_create_user_command('W', "w", {}) -- because this always becomes uppercase for some reason

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

-- zen mode
vim.keymap.set('', '<leader>g', ':ZenMode<CR>')

-- config keybindings
local initFile = '~/.config/nvim/init.lua'
local cmdRefresh = ':so ' .. initFile .. '<CR>'
vim.keymap.set('n', '<leader>,e', ':e ' .. initFile .. '<CR>')
vim.keymap.set('n', '<leader>,r', cmdRefresh)
vim.keymap.set('n', '<leader>,p', cmdRefresh .. ':PaqSync<CR>')

-- buffer keybindings
vim.keymap.set('', '<leader><leader>' , "<C-^>")	-- navigate to MRU buffer
vim.keymap.set('', '<leader><BS>', ':bd!<CR>')		-- delete current buffer
vim.keymap.set('', '<C-s>', ':wall<CR>')

vim.keymap.set('', '<leader>p' , ":lua require'telescope.builtin'.find_files{hidden = true}<CR>")
vim.keymap.set('', '<leader>P' , ":lua require'telescope.builtin'.find_files{hidden = true, no_ignore = true}<CR>")
vim.keymap.set('', '<leader>b', ":lua require'telescope.builtin'.buffers{}<CR>")
vim.keymap.set('', '<leader>f', ":lua require'telescope.builtin'.live_grep{}<CR>")

vim.keymap.set('', '<leader>t' , ":Trouble diagnostics toggle<CR>")

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
vim.g.forceCursorCenter = false

local function toggle_cursor_center()
  vim.g.forceCursorCenter = not vim.g.forceCursorCenter
  if vim.g.forceCursorCenter then
    print("Cursor centering enabled")
  else
    print("Cursor centering disabled")
  end
end

vim.api.nvim_create_autocmd({"CursorMoved", "InsertLeave"}, {
  pattern = "*",
  callback = function()
    if vim.g.forceCursorCenter then
      vim.api.nvim_command('normal! zz')
    end
  end
})

vim.api.nvim_create_user_command('ToggleCenter', toggle_cursor_center, {})
vim.keymap.set('', '<leader>c', ':ToggleCenter<CR>')

-- insert agenda for sagyou.md
vim.keymap.set('n', '<leader>8', ':r!~/Scripts/agenda yesterday today<CR>')
vim.keymap.set('n', '<leader>9', ':r!~/Scripts/agenda today tomorrow<CR>')
vim.keymap.set('n', '<leader>0', ':r!~/Scripts/agenda tomorrow 2days<CR>')
