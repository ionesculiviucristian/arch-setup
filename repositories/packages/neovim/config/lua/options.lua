vim.opt.encoding = "utf-8" -- sets the character encoding used inside Vim
vim.opt.number = true -- print the line number in front of each line
vim.opt.relativenumber = true -- show the line number relative to the line with the cursor in front of each line

vim.opt.tabstop = 4 -- number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4 -- number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>
vim.opt.shiftwidth = 4 -- number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- in Insert mode: Use the appropriate number of spaces to insert a <Tab>
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.list = true -- show tabs as CTRL-I is displayed, display $ after end of line

vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true -- override the 'ignorecase' option if the search pattern contains upper	case characters

vim.opt.hlsearch = false -- when there is a previous search pattern, highlight all its matches
vim.opt.incsearch = true -- while typing a search command, show where the pattern, as it was typed so far, matches

vim.opt.termguicolors = true -- when on, uses highlight-guifg and highlight-guibg attributes in the terminal (thus using 24-bit color)

vim.opt.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- the minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set

vim.opt.signcolumn = "yes" -- always show the sign column to prevent layout shift from diagnostics
vim.opt.undofile = true -- save undo history to a file, persistent across sessions
vim.opt.splitright = true -- new vertical splits open to the right
vim.opt.splitbelow = true -- new horizontal splits open below
vim.opt.updatetime = 250 -- faster CursorHold events (default 4000ms)

-- https://lazy.folke.io/installation
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.diagnostic.config({ virtual_text = true })
