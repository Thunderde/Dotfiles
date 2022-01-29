let mapleader = ","

call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'neovim/nvim-lspconfig'

" treesitter
call plug#end()

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection= '0'
colorscheme gruvbox
set background=dark

lua require("lspconfig")
autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
autocmd BufWritePre *.go lua goimports(1000)

lua require'lspconfig'.gopls.setup{}
