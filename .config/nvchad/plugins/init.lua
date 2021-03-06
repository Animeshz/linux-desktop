return {
   ["elkowar/yuck.vim"] = { ft = "yuck" },
   ["gpanders/nvim-parinfer"] = {},
   ["jose-elias-alvarez/null-ls.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.null-ls").setup()
      end,
   },
   ["nvim-neorg/neorg"] = {
      ft = "norg",
      after = "nvim-treesitter",
      config = function()
         require('neorg').setup {
            load = {
               ["core.defaults"] = {}
            }
         }
      end
   },
   ['mg979/vim-visual-multi'] = {},
   ['phaazon/hop.nvim'] = {
      config = function()
         require('hop').setup()
      end
   }
}
