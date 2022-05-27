-- ===== AutoCmd =====
vim.api.nvim_command("autocmd Filetype json setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2")
vim.api.nvim_command("autocmd Filetype lua setlocal expandtab tabstop=3 shiftwidth=3 softtabstop=3")
vim.api.nvim_command("autocmd BufWritePre * :%s/\\s\\+$//e")  -- autoremove trailing spaces

vim.api.nvim_command("command! W exe '!mkdir -p %:h'|exe 'w'")  -- https://stackoverflow.com/a/44161948/11377112
vim.api.nvim_command("command! Ws lua require('custom.sudo_write').sudowrite()")

-- ===== KeyBindings =====
local map = nvchad.map
local mapl = vim.keymap.set

mapl("n", "<leader>c" , function()     -- Toggle colorcolumn
   vim.opt.colorcolumn = vim.api.nvim_get_option_value('colorcolumn', {}) ~= '' and '' or '120'
end)

map("n", "H", "0", {})
map("v", "H", "0", {})
map("o", "H", "0", {})
map("n", "J", "G", {})
map("v", "J", "G", {})
map("o", "J", "G", {})
map("n", "K", "gg", {})
map("v", "K", "gg", {})
map("o", "K", "gg", {})
map("n", "L", "$", {})
map("v", "L", "$", {})
map("o", "L", "$", {})

map("n", ".", "<C-y>", {})
map("n", ",", "<C-e>", {})
map("n", ">", "10<C-y>", {})
map("n", "<", "10<C-e>", {})

map("n", "go", "<cmd>HopWord<CR>", {})
map("v", "go", "<cmd>HopWord<CR>", {})
map("o", "go", "<cmd>HopWord<CR>", {})

map("n", "gl", "<cmd>HopChar1<CR>", {})
map("v", "gl", "<cmd>HopChar1<CR>", {})
map("o", "gl", "<cmd>HopChar1<CR>", {})

-- https://mr-destructive.github.io/techstructive-blog/vim/comnpetitive-programming/2021/09/13/Vim-for-cp.html
map("n", "cpf", "i#include <bits/stdc++.h><Esc>ousing namespace std;<Esc>o<CR>int main() {<Esc>o<Esc>oreturn 0;<Esc>o}<Esc>kki")
map("n", "cp", "i#include <stdio.h><Esc>o<CR>int main() {<Esc>o<Esc>oreturn 0;<Esc>o}<Esc>kki")
-- TODO: evaluate expand when mapping is called
mapl("n", "cpj" , function()
   vim.api.nvim_input("ipublic class " .. vim.fn.expand("%:t:r") .. " {<Esc>opublic static void main(String args[]) {<Esc>o<Esc>o}<Esc>o}<Esc>kki")
end)

-- https://stackoverflow.com/a/44161948/11377112
-- vim.api.nvim_command("command! W exe '!mkdir -p %:h'|exe 'w'")
--vim.api.nvim_command("command! Sw exe ':w !sudo -S tee %'")

-- ===== Extra =====
vim.api.nvim_command("highlight ExtraWhitespace ctermbg=red guibg=red")
vim.api.nvim_command("match ExtraWhitespace /\\s\\+$/")

require("luasnip.loaders.from_snipmate").load({ paths = { "./snippets" } })
