call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')

Plug 'morhetz/gruvbox'

"lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

"snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

"telescope
"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

"cmp setup
lua <<EOF
local has_words_before = function()
local line, col = unpack(vim.api.nvim_win_get_cursor(0))
return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local luasnip = require'luasnip'
    local cmp = require'cmp'

    cmp.setup({
    snippet = {
        expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
    },
mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({i = cmp.mapping.abort(),c = cmp.mapping.close(),}),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    elseif has_words_before() then
        cmp.complete()
    else
        fallback()
    end
end, { "i", "s" }),

["<S-Tab>"] = cmp.mapping(function(fallback)
if cmp.visible() then
    cmp.select_prev_item()
elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
else
    fallback()
end
end, { "i", "s" }),
},
    sources = cmp.config.sources({
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    })
})

  cmp.setup.cmdline('/', {
      sources = {
          { name = 'buffer' }
          }
      })

  cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
      { name = 'path' }
      }, {
      { name = 'cmdline' }
      })
  })

-- from ThePrimeagen
local function config(_config)
return vim.tbl_deep_extend("force", {
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }, _config or {})
end

require("lspconfig").gopls.setup(config({
cmd = { "gopls", "serve" },
settings = {
    gopls = {
        analyses = {
            unusedparams = true,
            },
        staticcheck = true,
        },
    },
}))

local snippets_paths = function()
local plugins = { "friendly-snippets" }
local paths = {}
local path
local root_path = vim.env.HOME .. "/.vim/plugged/"
for _, plug in ipairs(plugins) do
    path = root_path .. plug
    if vim.fn.isdirectory(path) ~= 0 then
        table.insert(paths, path)
    end
end
return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
paths = snippets_paths(),
include = nil, -- Load all languages
exclude = {},
})
EOF

"sets
let mapleader = ","
set wildmode=longest,list,full
set wildmenu
set relativenumber
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set noswapfile
set updatetime=50

"Styling
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection= '0'
colorscheme gruvbox
set background=dark


"treesitter config
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
