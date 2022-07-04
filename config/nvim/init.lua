-- https://github.com/albingroen/quick.nvim as a base
-------------
-- Loading --
-------------

require('basics')
require('colors')
require('package-configs')
require('lualine').setup()

-------------
-- Plugins --
-------------

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "bash", "python", "lua", "r", "julia" },
  context_commentstring = {
    enable = true
  },
  highlight = {
    enable = true,
    disable = { "lua" }
  },
  indent = {
    enable = true
  }
}

require'nvim-web-devicons'.setup {
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 default = true;
}


return require('packer').startup(function()
  --simple--
  use {'neoclide/coc.nvim', branch = 'release'}
  use 'nvim-treesitter/nvim-treesitter' 
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use 'tpope/vim-commentary'
  use 'kyazdani42/nvim-web-devicons'
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use 'mhinz/vim-startify'
  --complex--
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    "ur4ltz/surround.nvim",
    config = function()
      require"surround".setup {mappings_style = "surround"}
    end
  }
  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end 
  }
end)
