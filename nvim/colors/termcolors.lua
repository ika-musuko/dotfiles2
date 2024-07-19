vim.opt.background = 'dark'

local Black   = "0"
local Red     = "1"
local Green   = "2"
local Yellow  = "3"
local Blue    = "4"
local Magenta = "5"
local Cyan    = "6"
local White   = "7"
local BrightBlack   = "8"
local BrightRed     = "9"
local BrightGreen   = "10"
local BrightYellow  = "11"
local BrightBlue    = "12"
local BrightMagenta = "13"
local BrightCyan    = "14"
local BrightWhite   = "15"
local None = "none"

local function color(group, fg, bg)
  vim.cmd("highlight " .. group .. " ctermfg=" .. fg .. " ctermbg=" .. bg)
end

vim.cmd("highlight Normal     ctermfg=7")
color("Normal", White, None)

color("Whitespace", BrightBlack,   None)
color("LineNr",	    BrightBlack,   None)
color("Comment",    Green,	   None)
color("Constant",   Blue,          None)
color("Number",	    Yellow,        None)
color("String",	    BrightGreen,   None)
color("Character",  BrightBlue,    None)
color("Identifier", Blue,          None)
color("Statement",  BrightMagenta, None)
color("Type",	    Cyan,          None)
color("Operator",   BrightWhite,   None)
color("PreProc",    BrightBlue,    None)

vim.cmd("highlight StatusLine	     ctermbg=0 ctermfg=7")
vim.cmd("highlight StatusLineNC      ctermbg=8 ctermfg=0")
vim.cmd("highlight TabLine	     cterm=none ctermfg=8")
vim.cmd("highlight BufTabLineCurrent ctermbg=0 ctermfg=15 cterm=bold")
vim.cmd("highlight BufTabLineActive  ctermbg=0 ctermfg=8")
vim.cmd("highlight BufTabLineHidden  cterm=none ctermfg=8")
vim.cmd("highlight BufTabLineFill    cterm=none ctermfg=8")

vim.cmd("highlight Pmenu    ctermbg=0 ctermfg=15")
vim.cmd("highlight PmenuSel ctermbg=15 ctermfg=0")
