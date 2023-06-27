local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- "folke/which-key.nvim",
  -- { "folke/neoconf.nvim", cmd = "Neoconf" },
  -- "folke/neodev.nvim",
  -- "neoclide/coc.nvim",
  {"nvim-tree/nvim-tree.lua", version = "*", 
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        sort_by = "case_sensitive",
        view = {
            width = 30,
        },
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = true,
        }
  }end},
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"baliestri/aura-theme", lazy = false, priority = 1000, config = function(plugin)
    vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
    vim.cmd([[colorscheme aura-dark]])
  end}
})
