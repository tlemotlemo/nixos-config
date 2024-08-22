vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.g.mapleader = " "

local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
if gdproject then
    io.close(gdproject)
    vim.fn.serverstart './godothost'
end
