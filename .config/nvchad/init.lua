-- ===== AutoCmd =====
vim.api.nvim_command("autocmd Filetype json setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2")
vim.api.nvim_command("autocmd Filetype lua setlocal expandtab tabstop=3 shiftwidth=3 softtabstop=3")
vim.api.nvim_command("autocmd BufWritePre * :%s/\\s\\+$//e")  -- autoremove trailing spaces


-- ===== KeyBindings =====
local map = require("core.utils").map

-- https://mr-destructive.github.io/techstructive-blog/vim/comnpetitive-programming/2021/09/13/Vim-for-cp.html
map("n", "cpf", "i#include <bits/stdc++.h><Esc>ousing namespace std;<Esc>o<CR>int main() {<Esc>o<Esc>oreturn 0;<Esc>o}<Esc>kki")
map("n", "cp", "i#include <stdio.h><Esc>o<CR>int main() {<Esc>o<Esc>oreturn 0;<Esc>o}<Esc>kki")
-- TODO: evaluate expand when mapping is called
map("n", "cpj", "ipublic class " .. vim.fn.expand("%:t:r") .. " {<Esc>opublic static void main(String args[]) {<Esc>o<Esc>o}<Esc>o}<Esc>kki")

-- https://stackoverflow.com/a/44161948/11377112
vim.api.nvim_command("command! W exe '!mkdir -p %:h'|exe 'w'")

-- ===== Extra =====
vim.api.nvim_command("highlight ExtraWhitespace ctermbg=red guibg=red")
vim.api.nvim_command("match ExtraWhitespace /\\s\\+$/")
