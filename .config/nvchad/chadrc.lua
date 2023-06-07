-- inherit: lua/core/default_config.lua

local M = {}

M.ui = {
   theme = "onedark",
}

M.plugins = "custom.plugins"

local movement = {
   ["H"] = {"0"},
   ["J"] = {"G"},
   ["K"] = {"gg"},
   ["L"] = {"$"},
   ["go"] = {"<cmd>HopWord<CR>"},
   ["gl"] = {"<cmd>HopChar1<CR>"},
}

M.mappings = {
   primary = {
      n = movement,
      o = movement,
      v = movement,
   },

   misc = {
      n = {
         ["."] = {"<C-y>"},
         [","] = {"<C-e>"},
         [">"] = {"10<C-y>"},
         ["<"] = {"10<C-e>"},

         -- https://mr-destructive.github.io/techstructive-blog/vim/comnpetitive-programming/2021/09/13/Vim-for-cp.html
         ["cpf"] = {"i#include <bits/stdc++.h><Esc>ousing namespace std;<Esc>o<CR>int main() {<Esc>o<Esc>oreturn 0;<Esc>o}<Esc>kki"},
         ["cp"] = {"i#include <stdio.h><Esc>o<CR>int main() {<Esc>o<Esc>oreturn 0;<Esc>o}<Esc>kki"},
         ["cpj"] = {
            function()
               -- TODO: evaluate expand when mapping is called
               vim.api.nvim_input("ipublic class " .. vim.fn.expand("%:t:r") .. " {<Esc>opublic static void main(String args[]) {<Esc>o<Esc>o}<Esc>o}<Esc>kki")
            end
         },

         ["<leader>c"] = {
            function()     -- Toggle colorcolumn
               vim.opt.colorcolumn = vim.api.nvim_get_option_value('colorcolumn', {}) ~= '' and '' or '120'
            end
         },
      }
   }
}

return M
