local map = require("core.utils").map

-- https://mr-destructive.github.io/techstructive-blog/vim/comnpetitive-programming/2021/09/13/Vim-for-cp.html
map("n", "cpf", "i#include <iostream><Esc>ousing namespace std;<Esc>o<CR>int main() {<Esc>o<Esc>oreturn 0;<Esc>o}<Esc>kki")
map("n", "cp", "i#include <stdio.h><Esc>o<CR>int main() {<Esc>o<Esc>oreturn 0;<Esc>o}<Esc>kki")

-- https://stackoverflow.com/a/44161948/11377112
vim.api.nvim_command("command! W exe '!mkdir -p %:h'|exe 'w'")

-- vim.api.nvim_add_user_command("W", "!mkdir -p %:h | w")

