-- inherit: lua/core/default_config.lua

local M = {}

M.options = {
   user = function()
      local opt = vim.opt
      opt.relativenumber = true
      opt.shiftwidth = 4
   end
}

M.plugins = {
   user = require("custom.plugins"),
}

M.ui = {
   theme = "onedark",
}

return M
