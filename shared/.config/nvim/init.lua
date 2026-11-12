-- LEADER KEY
vim.g.mapleader = " "

-- LINE NUMBERS
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- INDENTATION
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- INDENTATION GUIDES
vim.opt.list = false

local has_ibl, ibl = pcall(require, "ibl")
if has_ibl then ibl.setup({
  indent = {
    char = "│",
  },
  scope = {
    enabled = true,
    show_start = true,
    show_end = true,
  },
}) end

-- SYSTEM CLIPBOARD
vim.opt.clipboard = "unnamedplus"

-- SYNTAX HIGHLIGHTING
vim.opt.termguicolors = true
vim.cmd("syntax on")
vim.cmd.colorscheme("habamax")

-- CUSTOM KEYBINDS
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", {
  desc = "Save file",
})

vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", {
  desc = "Quit Neovim",
})
-- Paste from system clipboard
vim.keymap.set("n", "<C-v>", '"+p', {
  desc = "Paste clipboard in Normal mode",
})

vim.keymap.set("i", "<C-v>", "<C-r>+", {
  desc = "Paste clipboard in Insert mode",
})
