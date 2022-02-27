-- inherit: lua/core/default_config.lua
local M = {}

M.options = {
    relativenumber = true,
    shiftwidth = 4,
}

M.plugins = {
    install = require "custom.plugins"
}

M.ui = {
    theme = "onedark",
}

return M
