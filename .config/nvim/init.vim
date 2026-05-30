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
Plug 'rebelot/kanagawa.nvim'

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

colorscheme kanagawa-dragon

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

" ============================================
" LIQUID GLASS для Neovim (vimscript)
" Требует: termguicolors + прозрачный терминал
" ============================================

set termguicolors

" --- Прозрачный фон (blur от Kitty/niri) ---
highlight Normal           guibg=NONE  ctermbg=NONE
highlight NormalNC         guibg=NONE  ctermbg=NONE
highlight EndOfBuffer      guibg=NONE  ctermbg=NONE
highlight SignColumn        guibg=NONE  ctermbg=NONE
highlight LineNr            guibg=NONE  ctermbg=NONE guifg=#4a4a8a
highlight FoldColumn        guibg=NONE  ctermbg=NONE
highlight VertSplit         guibg=NONE  guifg=#2a2a5a

" --- Floating окна - стеклянные панели ---
" winblend: 0=непрозрачное, 100=полностью прозрачное
set winblend=18
set pumblend=18

highlight NormalFloat  guibg=#0f0c1e guifg=#d8d8f0
highlight FloatBorder  guibg=NONE    guifg=#5050a0

" --- Completion menu (Pmenu) ---
highlight Pmenu        guibg=#12102a guifg=#c8c8f0
highlight PmenuSel     guibg=#2a2460 guifg=#ffffff gui=bold
highlight PmenuSbar    guibg=#0a0818
highlight PmenuThumb   guibg=#4040a0

" --- CursorLine - стеклянная подсветка ---
set cursorline
highlight CursorLine   guibg=#1a1530 ctermbg=NONE  gui=NONE
highlight CursorLineNr guibg=NONE    guifg=#8888cc gui=bold

" --- Statusline glass ---
highlight StatusLine   guibg=#1a1535 guifg=#a0a0d0 gui=NONE
highlight StatusLineNC guibg=#0d0b1e guifg=#4a4a7a gui=NONE

" --- Search highlight - цветное стекло ---
highlight Search       guibg=#2a1f60 guifg=#e0e0ff gui=NONE
highlight IncSearch    guibg=#4a3080 guifg=#ffffff  gui=bold

" --- Visual selection ---
highlight Visual       guibg=#1e1850 guifg=NONE

" --- Syntax glass-палитра (опционально) ---
" Мягкие тона под стеклянную эстетику
highlight Comment      guifg=#4a5580 gui=italic
highlight String       guifg=#7080c0
highlight Keyword      guifg=#9070d0 gui=bold
highlight Function     guifg=#6090e0
highlight Type         guifg=#70a0c0
highlight Number       guifg=#a080d0
highlight Special      guifg=#80a0d0

" --- Автоприменение при смене colorscheme ---
augroup LiquidGlass
  autocmd!
  autocmd ColorScheme * highlight Normal      guibg=NONE ctermbg=NONE
  autocmd ColorScheme * highlight NormalNC    guibg=NONE ctermbg=NONE
  autocmd ColorScheme * highlight EndOfBuffer guibg=NONE ctermbg=NONE
  autocmd ColorScheme * highlight SignColumn  guibg=NONE ctermbg=NONE
augroup END

lua << EOF
-- новый API lspconfig v3
vim.lsp.config('clangd', {
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp" },
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end,
})
vim.lsp.enable('clangd')

-- автодополнение (это остаётся без изменений)
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>']     = cmp.mapping.select_next_item(),
    ['<S-Tab>']   = cmp.mapping.select_prev_item(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
})
EOF
