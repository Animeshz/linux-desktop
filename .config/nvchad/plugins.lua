local plugins = {
   {"elkowar/yuck.vim"},
   {"gpanders/nvim-parinfer"},
   -- ["jose-elias-alvarez/null-ls.nvim"] = {
   --    after = "nvim-lspconfig",
   --    config = function()
   --       require("custom.plugins.null-ls").setup()
   --    end,
   -- },
   -- ["nvim-neorg/neorg"] = {
   --    ft = "norg",
   --    after = "nvim-treesitter",
   --    config = function()
   --       require('neorg').setup {
   --          load = {
   --             ["core.defaults"] = {}
   --          }
   --       }
   --    end
   -- },
   {'mg979/vim-visual-multi'},
   {'phaazon/hop.nvim',
      lazy = false,
      config = function()
         require('hop').setup()
      end,
   }

--    builtins = {
--       "netrw"
--    }
--    override = {
--       ["NvChad/ui"] = {
--          tabufline = {
--              enabled = true,
--              lazyload = false
--          }
--       },
--       ["folke/which-key.nvim"] = {
--          disable = false
--       }
--    }
}

return plugins
