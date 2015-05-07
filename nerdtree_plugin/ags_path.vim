" ============================================================================
" File:        ags_path.vim
" Description: plugin for NERD Tree that does an ag search under the selected
" path. (Requires the vim-ags plugin.)
" Maintainer:  Po Shan Cheah <morton@mortonfox.com>
" Last Change: May 7, 2015
" ============================================================================
if exists("g:loaded_nerdtree_ags_path")
    finish
endif
let g:loaded_nerdtree_ags_path = 1

" Add menu item to NERD Tree to do an ag search under the selected path.
call NERDTreeAddMenuItem({'text': 'vim-a(G)s search', 'shortcut': 'G', 'callback': 'NERDTreeAgsPath'})

function! NERDTreeAgsPath()
    let curDirNode = g:NERDTreeDirNode.GetSelected()
    let path = curDirNode.path.str()
    
    call inputsave()
    let search_arg = input('Search for? ')
    call inputrestore()

    if search_arg != ''
        call ags#search(fnameescape(search_arg).' '.fnameescape(path))
    endif
endfunction

" vim: set tw=0 sw=4:
