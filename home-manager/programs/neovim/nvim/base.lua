local o = vim.opt
local w = vim.wo

vim.scriptencoding = 'utf-8'
o.encoding = 'utf-8'
o.fileencoding = 'utf-8'

o.title = true
o.number = true
o.backup = false
o.hlsearch = true
o.smarttab = true
o.breakindent = true
o.shiftwidth = 2
o.tabstop = 2
o.ai = true -- Auto indent
o.si = true -- Smart indent
o.wrap = true

o.showcmd = true
o.cmdheight = 1
o.laststatus = 2
o.clipboard:append { 'unnamedplus' }
