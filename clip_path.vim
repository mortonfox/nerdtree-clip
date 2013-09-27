" ============================================================================
" File:        clip_path.vim
" Description: plugin for NERD Tree that copies selected path to clipboard
" Maintainer:  Po Shan Cheah <morton@mortonfox.com>
" Last Change: September 27, 2013
" ============================================================================
if exists("g:loaded_nerdtree_clip_path")
    finish
endif
let g:loaded_nerdtree_clip_path = 1

" Add menu item to NERD Tree to copy selected item's path to clipboard.
if has("clipboard")
    call NERDTreeAddMenuItem({'text': 'copy path to clip(b)oard', 'shortcut': 'b', 'callback': 'NERDTreeClipPath'})
endif

function! NERDTreeClipPath()
    let curFileNode = g:NERDTreeFileNode.GetSelected()
    let path = curFileNode.path.str()

    let @* = path
    redraw
    echomsg 'Copied to clipboard: '.path
endfunction
