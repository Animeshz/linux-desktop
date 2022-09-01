-- ===== AutoCmd =====
vim.api.nvim_command("autocmd Filetype json setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2")
vim.api.nvim_command("autocmd Filetype lua setlocal expandtab tabstop=3 shiftwidth=3 softtabstop=3")
vim.api.nvim_command("autocmd BufWritePre * :%s/\\s\\+$//e")  -- autoremove trailing spaces

vim.api.nvim_command("command! W exe '!mkdir -p %:h'|exe 'w'")  -- https://stackoverflow.com/a/44161948/11377112
vim.api.nvim_command("command! Ws lua require('custom.sudo_write').sudowrite()")

-- ===== KeyBindings =====

local opt = vim.opt
opt.relativenumber = true
-- opt.shiftwidth = 4


-- -- ===== Extra =====
vim.api.nvim_command("highlight ExtraWhitespace ctermbg=red guibg=red")
vim.api.nvim_command("match ExtraWhitespace /\\s\\+$/")

vim.g.luasnippets_path = "./snippets"
