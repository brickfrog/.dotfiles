-- https://github.com/albingroen/quick.nvim as a base
-------------
-- Loading --
-------------

require('basics')
require('package-configs')
require('lualine').setup()

-------------
-- Plugins --
-------------
local pywal = require('pywal')

pywal.setup()

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
  use 'tpope/vim-commentary'
  use 'kyazdani42/nvim-web-devicons'
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use 'mhinz/vim-startify'
  use 'neovim/nvim-lsp'
  use 'neovim/nvim-lspconfig'
  use 'jpalardy/vim-slime'
  --complex--
  use { 'AlphaTechnolog/pywal.nvim', as = 'pywal' }
  use {
     'hrsh7th/nvim-cmp',
    requires = {
      { "hrsh7th/cmp-vsnip", after = "nvim-cmp" },
      { "hrsh7th/vim-vsnip", after = "nvim-cmp", requires = "hrsh7th/vim-vsnip-integ" },
      { "kdheepak/cmp-latex-symbols", after = "nvim-cmp" }
    }
  }
  use {
    'glepnir/lspsaga.nvim', branch = 'main', after = 'nvim-lspconfig'
  }
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
