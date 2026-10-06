" Basic Settings
:set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set clipboard=unnamedplus
:set cmdheight=0
call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/ap/vim-css-color'
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/tc50cal/vim-terminal'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'folke/noice.nvim'
Plug 'slugbyte/lackluster.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
" LSP
Plug 'neovim/nvim-lspconfig'

" Автодополнение
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

call plug#end()

lua << EOF
require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },

  cmdline = {
    enabled = true,
    view = "cmdline_popup",
  },

  messages = {
    enabled = true,
    view = "notify",
  },

  popupmenu = {
    enabled = true,
    backend = "nui",
  },

  notify = {
    enabled = true,
  },
})
EOF

lua << EOF
vim.notify = require("notify")
EOF

lua << EOF
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,  
  integrations = {
    nerdtree = true,           
	},
})
EOF

" Включаем цветовую схему
colorscheme catppuccin-mocha

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
vnoremap <C-c> "+y
nnoremap <C-c> "+yy
vnoremap <C-v> "+p
nnoremap <C-v> "+p

nnoremap <F5> :w<CR>:call BuildAndRun()<CR>

function! BuildAndRun()
  let root = findfile('CMakeLists.txt', '.;')
  if root == ''
    echo "CMakeLists.txt не найден"
    return
  endif
  let root_dir = fnamemodify(root, ':p:h')
  let build_dir = root_dir . '/build'

  botright split
  execute 'terminal bash -c "cd ' . build_dir . ' && cmake --build . && ./main; echo \"\n--- готово, нажми Enter ---\"; read"'
endfunction
